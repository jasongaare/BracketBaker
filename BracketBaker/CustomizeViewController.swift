//
//  ViewController.swift
//  BracketBaker
//
//  Created by Jason Gaare on 12/7/15.
//  Copyright © 2015 Jason Gaare. All rights reserved.
//

import UIKit

class CustomizeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    // MARK: Global Variables
    
    var dataLoaded = false
    
    // This is the text when there is no team selected
    let placeholder = "---"
    
    var masterDataArray : [[String]] = []
    
    var southRegionArray : [[String]] = []
    var eastRegionArray : [[String]] = []
    var westRegionArray : [[String]] = []
    var midwestRegionArray : [[String]] = []
    
    var southSorted : [[String]] = []
    var eastSorted : [[String]] = []
    var westSorted : [[String]] = []
    var midwestSorted : [[String]] = []
    
    let winnerPicker = UIPickerView()
    let southPicker = UIPickerView()
    let eastPicker = UIPickerView()
    let westPicker = UIPickerView()
    let midwestPicker = UIPickerView()
    
    // Midwest & West Winner
    let finalPicker1 = UIPickerView()
    // South & East Winner
    let finalPicker2 = UIPickerView()
    
    
    // MARK: View Load/Unload Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // *----1----*
        // We want to ensure we have a file on device with the bracket seedings
        let seedingFile = FileSaveHelper(fileName: "currentSeedings", fileExtension: .TXT, subDirectory: "SaveFiles", directory: .DocumentDirectory)
        // If we don't have the file, create it
        if !seedingFile.fileExists {
            do {
                // This is just a placeholder
                try seedingFile.saveFile(string: "JDG")
                print("Creating file")
            }
            catch {
                print(error)
            }
        }
        
        // *----2----*
        // Let's get the data we need
        if retreiveData(seedingFile) {
            print("Data loaded.")
            dataLoaded = true
            
            
            
        // *----3----*
        // Set up our regional arrays and populate the various pickers
            
            // Sort the master into the regions
            populateInitialArrays()
            
            winnerPicker.delegate = self
            southPicker.delegate = self
            eastPicker.delegate = self
            westPicker.delegate = self
            midwestPicker.delegate = self
            finalPicker1.delegate = self
            finalPicker2.delegate = self
            
            
            // Let's open the picker, instead of a keyboard, for these fields
            eastFinalTextField.inputView = eastPicker
            southFinalTextField.inputView = southPicker
            westFinalTextField.inputView = westPicker
            midwestFinalTextField.inputView = midwestPicker
            finalOneTextField.inputView = finalPicker1
            finalTwoTextField.inputView = finalPicker2
            winnerPickerTextField.inputView = winnerPicker
            
            // Sort arrays by seeding
            southSorted = southRegionArray.sort {Int($0[1]) < Int($1[1])}
            eastSorted = eastRegionArray.sort {Int($0[1]) < Int($1[1])}
            westSorted = westRegionArray.sort {Int($0[1]) < Int($1[1])}
            midwestSorted = midwestRegionArray.sort {Int($0[1]) < Int($1[1])}
            
            // Set initial text
            eastFinalTextField.text = self.placeholder
            southFinalTextField.text = self.placeholder
            westFinalTextField.text = self.placeholder
            midwestFinalTextField.text = self.placeholder
            finalOneTextField.text = self.placeholder
            finalTwoTextField.text = self.placeholder
            winnerPickerTextField.text = self.placeholder
            
            // Made it!
            print("Completed launch.")
            
            
            
        // This bracket ends our "if data loaded" block
        }
            
            
        // If we couldn't find data anywhere, then this app is worthless
        // Should rarely get here, however.
        else {
            dataLoaded = false
            // Do nothing 
            // Alert presents in viewDidAppear
        }
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if(!dataLoaded)
        {
            let alert = UIAlertController(title: "No Data", message: "Functionality limited due to lack of data. Try again with working network connection.", preferredStyle: UIAlertControllerStyle.Alert)
            let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(okayAction)
            presentViewController(alert, animated: true) { () -> Void in }
        }

        
    }
    

    // MARK: Data Manipulation
    
    func retreiveData(seedingFile: FileSaveHelper) -> Bool {
        
        // Local variables (we want this to be equal in the end)
        var currentSaveFile = ""
        var rawDataString = ""
        
        // Get the string of the current save file
        do {
            currentSaveFile = try seedingFile.getContentsOfFile()
            print("Found the file")
        }
        catch
        {
            print(error)
        }
        
        
        // Dropbox: 2015seedings.txt
        // Line information: [bracket region] / [regional seeding] / [team name] / [RPI ranking]
        let pathURL = "https://www.dropbox.com/s/wzempl4ani1gt9c/2015seeding.txt?dl=1"
        
        // Fetch data from 'pathURL' and put it in a the master data array
        do {
            
            let rawBracketData = try NSData(contentsOfURL: NSURL(string: pathURL)!, options: NSDataReadingOptions())
            rawDataString = NSString(data: rawBracketData, encoding: NSUTF8StringEncoding)! as String
            print("Got the file online")
        } catch {
            print(error)
        }
        
        // If the saved data and live data are not the same, figure out why!
        if currentSaveFile != rawDataString
        {
            print("Uh oh! The files are different")
            // Maybe we don't have a data connection (can't access URL)
            if rawDataString == ""
            {
                // As long as our save file is not the initial file, we can proceed
                // Initial file would == "JDG"
                if currentSaveFile == "JDG"
                {
                    print("No data found on device or online.")
                    return false;
                }
            }
            else {
                print("Better set the save file to the one online")
                // If they are not equal, BUT we have retreived a file from URL, then update save file
                do {
                    print("Updating File")
                    
                    // Try to save to disk (long term)
                    try seedingFile.saveFile(string: rawDataString)

                    // Also update our current working (short term) string
                    currentSaveFile = rawDataString
                }
                catch {
                    print(error)
                }
            }
        }
        
        // Unless we returned without data, we can proceed to populate masterDataArray
        
        //Separate by lines, then separate lines into the master data array
        let linesOfData = currentSaveFile.componentsSeparatedByString("\n")
        for ix in linesOfData {
            masterDataArray.append(ix.componentsSeparatedByString("/"))
        }
        
        return true
    }
    
    // This is just to organize the data in different ways, for easier accessability
    func populateInitialArrays() {
        
        for ix in masterDataArray {
            switch Int(ix[0])! {
                case 1:
                    midwestRegionArray.append(ix)
                case 2:
                    westRegionArray.append(ix)
                case 3:
                    eastRegionArray.append(ix)
                case 4:
                    southRegionArray.append(ix)
                default: break
            }
        }
        
    }

    
    // MARK: UIPickerView Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // Our data depends on which picker we have, so let's determine that first
        var thisPickerArray : [[String]] = []
        
        switch pickerView {
        case southPicker:
            thisPickerArray = southSorted
        case eastPicker:
            thisPickerArray = eastSorted
        case westPicker:
            thisPickerArray = westSorted
        case midwestPicker:
            thisPickerArray = midwestSorted
        case finalPicker1:
            thisPickerArray = finalPicker1Helper()
        case finalPicker2:
            thisPickerArray = finalPicker2Helper()
        case winnerPicker:
            thisPickerArray = winnerPickerHelper()
        default:
            thisPickerArray = masterDataArray
        }
        
        return (thisPickerArray.count + 1)
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // Our data depends on which picker we have, so let's determine that first
        var thisPickerArray : [[String]] = []
        
        switch pickerView {
            case southPicker:
                thisPickerArray = southSorted
            case eastPicker:
                thisPickerArray = eastSorted
            case westPicker:
                thisPickerArray = westSorted
            case midwestPicker:
                thisPickerArray = midwestSorted
            case finalPicker1:
                thisPickerArray = finalPicker1Helper()
            case finalPicker2:
                thisPickerArray = finalPicker2Helper()
            case winnerPicker:
                thisPickerArray = winnerPickerHelper()
            default:
                thisPickerArray = masterDataArray
        }
        
        // Sort by seed
        thisPickerArray = thisPickerArray.sort {Int($0[1]) < Int($1[1])}
        
        if row == 0 {
            return self.placeholder
        }
        else {
            // [Seed]. [Team Name]
            return "\(thisPickerArray[row-1][1]). \(thisPickerArray[row-1][2])"
        }
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        // Our data depends on which picker we have, so let's determine that first
        var thisPickerTextField = UITextField()
        var thisPickerArray : [[String]] = []
        
        switch pickerView {
            
        case southPicker:
            thisPickerTextField = southFinalTextField
            thisPickerArray = southSorted
            finalPicker2.reloadAllComponents()
            
        case eastPicker:
            thisPickerTextField = eastFinalTextField
            thisPickerArray = eastSorted
            finalPicker2.reloadAllComponents()
            
        case westPicker:
            thisPickerTextField = westFinalTextField
            thisPickerArray = westSorted
            finalPicker1.reloadAllComponents()
            
        case midwestPicker:
            thisPickerTextField = midwestFinalTextField
            thisPickerArray = midwestSorted
            finalPicker1.reloadAllComponents()
            
        case finalPicker1:
            thisPickerTextField = finalOneTextField
            thisPickerArray = finalPicker1Helper()
            
        case finalPicker2:
            thisPickerTextField = finalTwoTextField
            thisPickerArray = finalPicker2Helper()

        case winnerPicker:
            thisPickerTextField = winnerPickerTextField
            thisPickerArray = winnerPickerHelper()
            
        default:
            thisPickerTextField = winnerPickerTextField
            thisPickerArray = masterDataArray
        }
        
        
        // Sort by seed
        thisPickerArray = thisPickerArray.sort {Int($0[1]) < Int($1[1])}
        
        //Assign value
        if row == 0 {
            thisPickerTextField.text = self.placeholder
        }
        else {
            let teamName = thisPickerArray[row-1][2]
            thisPickerTextField.text = teamName
            
            // If this is the winner, we need to populate UPWARDS
            if(pickerView == winnerPicker) {
                // Get region of winner
                switch Int(thisPickerArray[row-1][0])! {
                case 1:
                    midwestFinalTextField.text = teamName
                    finalOneTextField.text = teamName
                case 2:
                    westFinalTextField.text = teamName
                    finalOneTextField.text = teamName
                case 3:
                    eastFinalTextField.text = teamName
                    finalTwoTextField.text = teamName
                case 4:
                    southFinalTextField.text = teamName
                    finalTwoTextField.text = teamName
                default : break
                }
            }
            
            // If this is the first final, we need to populate UPWARDS
            else if(pickerView == finalPicker1) {
                // Get region of winner
                switch Int(thisPickerArray[row-1][0])! {
                case 1:
                    midwestFinalTextField.text = teamName
                case 2:
                    westFinalTextField.text = teamName
                default: break
                }
            }
        
            // If this is the second final, we need to populate UPWARDS
            else if(pickerView == finalPicker2) {
                //Get region of winner
                switch Int(thisPickerArray[row-1][0])! {
                case 3:
                    eastFinalTextField.text = teamName
                case 4:
                    southFinalTextField.text = teamName
                default: break
                }
            }
        }
        
        // Close the picker
        thisPickerTextField.resignFirstResponder()
    }
   
    // MARK: Picker View Helpers
    // These help to reduce the need for duplicate code above
    
    func finalPicker1Helper() -> [[String]]  {
    
        var currentArray : [[String]] = []
        
        // If user selected a midwest team, we only want that as an option on the final
        if (midwestFinalTextField.text != self.placeholder) {
            
            // Find the team
            for ix in midwestSorted {
                if ix[2] == midwestFinalTextField.text {
                    currentArray.append(ix)
                    break
                }
            }
        }
        else {
            currentArray += midwestSorted
        }
        
        // If user selected a west team, we only want that as an option on the final
        if (westFinalTextField.text != self.placeholder) {
            
            //find the team
            for ix in westSorted {
                if ix[2] == westFinalTextField.text {
                    currentArray.append(ix)
                    break
                }
            }
        }
        else {
            currentArray += westSorted
        }
        
        return currentArray
    }
    
    
    func finalPicker2Helper() -> [[String]] {
        
        var currentArray : [[String]] = []
        
        // If user selected a midwest team, we only want that as an option on the final
        if (southFinalTextField.text != self.placeholder) {
            
            // Find the team
            for ix in southSorted {
                if ix[2] == southFinalTextField.text {
                    currentArray.append(ix)
                    break
                }
            }
        }
        else {
            currentArray += southSorted
        }
        
        // If user selected a west team, we only want that as an option on the final
        if (eastFinalTextField.text != self.placeholder) {
            
            //find the team
            for ix in eastSorted {
                if ix[2] == eastFinalTextField.text {
                    currentArray.append(ix)
                    break
                }
            }
        }
        else {
            currentArray += eastSorted
        }
        
        return currentArray
    }
    
    func winnerPickerHelper() -> [[String]] {
        
        var currentArray : [[String]] = []
        
        // If they've picked a semi winnner, no need to look at final four
        if (finalTwoTextField.text != self.placeholder) {
            
            // Find the team
            for ix in masterDataArray {
                if ix[2] == finalTwoTextField.text {
                    currentArray.append(ix)
                    break
                }
            }
            
        }
        else {
            
            // If user selected a midwest team, we only want that as an option on the final
            if (southFinalTextField.text != self.placeholder) {
                
                // Find the team
                for ix in southSorted {
                    if ix[2] == southFinalTextField.text {
                        currentArray.append(ix)
                        break
                    }
                }
            }
            else {
                currentArray += southSorted
            }
            
            // If user selected a west team, we only want that as an option on the final
            if (eastFinalTextField.text != self.placeholder) {
                
                //find the team
                for ix in eastSorted {
                    if ix[2] == eastFinalTextField.text {
                        currentArray.append(ix)
                        break
                    }
                }
            }
            else {
                currentArray += eastSorted
            }
        }
        
        // If they've picked a semi winnner, no need to look at final four
        if (finalOneTextField.text != self.placeholder) {
            
            // Find the team
            for ix in masterDataArray {
                if ix[2] == finalOneTextField.text {
                    currentArray.append(ix)
                    break
                }
            }
            
        }
        else {
            if (midwestFinalTextField.text != self.placeholder) {
                // Find the team
                for ix in midwestSorted {
                    if ix[2] == midwestFinalTextField.text {
                        currentArray.append(ix)
                        break
                    }
                }
            }
            else {
                currentArray += midwestSorted
            }
            
            // If user selected a west team, we only want that as an option on the final
            if (westFinalTextField.text != self.placeholder) {
                
                //find the team
                for ix in westSorted {
                    if ix[2] == westFinalTextField.text {
                        currentArray.append(ix)
                        break
                    }
                }
            }
            else {
                currentArray += westSorted
            }
            
        }
        
        return currentArray
    }
    
    
    // MARK: Actions

    @IBAction func createButtonClicked(sender: UIBarButtonItem) {
        
        // When the button is clicked, we want to capture the user customization preferences
        let theseUserPrefs = UserSelectedPrefs(mwFinal: midwestFinalTextField.text!, wFinal: westFinalTextField.text!, sFinal: southFinalTextField.text!, eFinal: eastFinalTextField.text!, final1: finalOneTextField.text!, final2: finalTwoTextField.text!, winner: winnerPickerTextField.text!)
        
        // Then we create the bracket, starting by sending the raw data over to the solver
        let bracket = BracketSolver(masterArray: masterDataArray, mwArray: midwestRegionArray, wArray: westRegionArray, sArray: southRegionArray, eArray: eastRegionArray, ph: placeholder)
        
        // Using the user preferences we fill out the bracket
        bracket.fillOutBracket(theseUserPrefs)
        
        
        midwestFinalTextField.text = bracket.mwFinal
        westFinalTextField.text = bracket.wFinal
        southFinalTextField.text = bracket.sFinal
        eastFinalTextField.text = bracket.eFinal
        finalOneTextField.text = bracket.final1
        finalTwoTextField.text = bracket.final2
        winnerPickerTextField.text = bracket.winner
        
        
        winnerLabel.text = "Winner is: \(bracket.winner)"
    }
    
    @IBAction func resetButtonClicked(sender: AnyObject) {
        
        // Change the text back to the placeholder
        midwestFinalTextField.text = self.placeholder
        westFinalTextField.text = self.placeholder
        southFinalTextField.text = self.placeholder
        eastFinalTextField.text = self.placeholder
        finalOneTextField.text = self.placeholder
        finalTwoTextField.text = self.placeholder
        winnerPickerTextField.text = self.placeholder
        
        // Spin the pickers back to the top
        midwestPicker.selectRow(0, inComponent: 0, animated: false)
        westPicker.selectRow(0, inComponent: 0, animated: false)
        southPicker.selectRow(0, inComponent: 0, animated: false)
        eastPicker.selectRow(0, inComponent: 0, animated: false)
        finalPicker1.selectRow(0, inComponent: 0, animated: false)
        finalPicker2.selectRow(0, inComponent: 0, animated: false)
        winnerPicker.selectRow(0, inComponent: 0, animated: false)
    }

    // MARK: Outlets and Connections
    
    @IBOutlet weak var winnerPickerTextField: UITextField!
    
    @IBOutlet weak var midwestFinalTextField: UITextField!
    @IBOutlet weak var westFinalTextField: UITextField!
    @IBOutlet weak var southFinalTextField: UITextField!
    @IBOutlet weak var eastFinalTextField: UITextField!
    @IBOutlet weak var finalOneTextField: UITextField!
    @IBOutlet weak var finalTwoTextField: UITextField!
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    @IBOutlet weak var winnerLabel: UILabel!
    
}