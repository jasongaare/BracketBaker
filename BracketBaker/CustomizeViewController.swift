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
    let placeholder = "Random"
    var year = ""
    
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
    let cinderellaPicker = UIPickerView()
    
    // Midwest & West Winner
    let finalPicker1 = UIPickerView()
    // South & East Winner
    let finalPicker2 = UIPickerView()
    
    var activeTF : UITextField = UITextField()
    
    
    // MARK: View Load/Unload Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // *----1----*
        
        // We want to have a file on device with the bracket seedings
        let seedingFile = FileSaveHelper(fileName: "currentSeedings", fileExtension: .TXT, subDirectory: "SaveFiles", directory: .DocumentDirectory)
        
        // If we don't have the file, create it
        if !seedingFile.fileExists {
           
            do {
                // This is creating a placeholder file containing JDG (first load only, generally)
                try seedingFile.saveFile(string: "JDG")
            }
            catch {
                print(error)
            }
            
            // We don't have data on the phone, so let's try to get it from online
            dataLoaded = retreiveData(seedingFile)

        }
        
        // If we have a file, let's use that first
        else {
            
            // Initialize with place holder
            var currentFileContents = "JDG"
            
            do {
                // Get contents of file on the phone
                currentFileContents = try seedingFile.getContentsOfFile()
            }
            catch {
                print(error)
                dataLoaded = false
            }
            
            // Let's check if the file has data
            if(currentFileContents == "JDG") {
                
                // If this is true, we've never received any data yet, only created a file on the phone
                // So let's retreive the data
                dataLoaded = retreiveData(seedingFile)
            }
            // If it does has data, we can proceed
            else{
                dataLoaded = true
                
                // Let's look online in the background, to see if we need to update a new file
                
                //* BACKGROUND
                //* ___________
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                    
                    // Run retreive data, will return true if we updated the file
                    let updateFile = self.updateData(seedingFile)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if (updateFile) {
                            
                            let alert = UIAlertController(title: "New data", message: "Updated tournament information found online. Would you like to refresh with new data?", preferredStyle: UIAlertControllerStyle.Alert)
                            let noAction = UIAlertAction(title: "Not now", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
                            let rAction = UIAlertAction(title: "Refesh", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                                
                                // Load data from updated save file
                                var newData = ""
                                do {
                                    newData = try seedingFile.getContentsOfFile()
                                }
                                catch {
                                    print(error)
                                }
                                
                                //Separate by lines, then separate lines into the master data array
                                let linesOfData = newData.componentsSeparatedByString("\n")
                                
                                // Get year from first line
                                self.year = linesOfData[0]
                                
                                self.currentYearLabel.text = "Data loaded from \(self.year) tournament"
                                
                                // Empty arrays
                                self.masterDataArray.removeAll()
                                self.southRegionArray.removeAll()
                                self.eastRegionArray.removeAll()
                                self.westRegionArray.removeAll()
                                self.midwestRegionArray.removeAll()
                                self.southSorted.removeAll()
                                self.eastSorted.removeAll()
                                self.westSorted.removeAll()
                                self.midwestSorted.removeAll()
                                
                                // Populate array from remaining lines
                                for line in 1...(linesOfData.count-1) {
                                    self.masterDataArray.append(linesOfData[line].componentsSeparatedByString("/"))
                                }
                                
                                // Sort into regions
                                self.populateInitialArrays()
                                
                                // Sorted arrays by seeding
                                self.southSorted = self.southRegionArray.sort {Int($0[1]) < Int($1[1])}
                                self.eastSorted = self.eastRegionArray.sort {Int($0[1]) < Int($1[1])}
                                self.westSorted = self.westRegionArray.sort {Int($0[1]) < Int($1[1])}
                                self.midwestSorted = self.midwestRegionArray.sort {Int($0[1]) < Int($1[1])}
                                
                            
                            }
                            alert.addAction(noAction)
                            alert.addAction(rAction)
                            alert.preferredAction = rAction
                            self.self.presentViewController(alert, animated: true) { () -> Void in }
                        }
                        else {
                            // Do nothing
                        }
                    }
                }
                //*____________
                
                //Separate by lines, then separate lines into the master data array
                let linesOfData = currentFileContents.componentsSeparatedByString("\n")
                    
                // Get year from first line
                self.year = linesOfData[0]
                    
                currentYearLabel.text = "Data loaded from \(self.year) tournament"
                    
                // Populate array from remaining lines
                for line in 1...(linesOfData.count-1) {
                    masterDataArray.append(linesOfData[line].componentsSeparatedByString("/"))
                }
                
            }
            
        }
        
        // *----2----*
        // Let's get the data we need
        if (dataLoaded) {
            
        // *----3----*
        // Set up our regional arrays and populate the various pickers
            
            // Sort the master into the regions
            populateInitialArrays()
            
            // Delegates for Pickers
            winnerPicker.delegate = self
            southPicker.delegate = self
            eastPicker.delegate = self
            westPicker.delegate = self
            midwestPicker.delegate = self
            finalPicker1.delegate = self
            finalPicker2.delegate = self
            cinderellaPicker.delegate = self
            
            // Delegates for TextFields
            cinderellaTF.delegate = self
            eastFinalTextField.delegate = self
            southFinalTextField.delegate = self
            westFinalTextField.delegate = self
            midwestFinalTextField.delegate = self
            finalOneTextField.delegate = self
            finalTwoTextField.delegate = self
            winnerPickerTextField.delegate = self
            cinderellaTF.delegate = self
            
            // Let's open a picker, instead of a keyboard, for these fields
            eastFinalTextField.inputView = eastPicker
            southFinalTextField.inputView = southPicker
            westFinalTextField.inputView = westPicker
            midwestFinalTextField.inputView = midwestPicker
            finalOneTextField.inputView = finalPicker1
            finalTwoTextField.inputView = finalPicker2
            winnerPickerTextField.inputView = winnerPicker
            cinderellaTF.inputView = cinderellaPicker
            
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
            cinderellaTF.text = "None"
            
            // Add toolbar to the pickers (with Close button)
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.Default
            toolBar.translucent = false
            toolBar.barTintColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            toolBar.tintColor = UIColor(red: 238/255, green: 129/255, blue: 47/255, alpha: 1)
            toolBar.sizeToFit()
            
            // Close Button
            let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
            // space after button
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            
            toolBar.setItems([closeButton, spaceButton], animated: false)
            toolBar.userInteractionEnabled = true
            
            // Add the close button to each of the pickers
            cinderellaTF.inputAccessoryView = toolBar
            eastFinalTextField.inputAccessoryView = toolBar
            southFinalTextField.inputAccessoryView = toolBar
            westFinalTextField.inputAccessoryView = toolBar
            midwestFinalTextField.inputAccessoryView = toolBar
            finalOneTextField.inputAccessoryView = toolBar
            finalTwoTextField.inputAccessoryView = toolBar
            winnerPickerTextField.inputAccessoryView = toolBar
        
        // *----4----*
        // We need to fix the appearance a little bit
            
            // Change color of resetButton
            resetButton.tintColor = UIColor.whiteColor()

            // Change the status bar
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            
        // This bracket ends our "if data loaded" block
        }
    }
    
    // Let the user know  if they don't have data
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // If we didn't find the data stored on the phone, or online
        if(!dataLoaded)
        {
            let alert = UIAlertController(title: "No Connection!", message: "App will not work under current conditions. Try again with working network connection.", preferredStyle: UIAlertControllerStyle.Alert)
            let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(okayAction)
            presentViewController(alert, animated: true) { () -> Void in }
        }
    }
    
    // MARK: Data Manipulation
    
    // Only called when we don't have the data on the phone
    func retreiveData(seedingFile: FileSaveHelper) -> Bool {
        
        var rawDataString = ""
        
        // Dropbox: 2015seedings.txt
        // Line information: [bracket region] / [regional seeding] / [team name] / [RPI ranking]
        let pathURL = "https://www.dropbox.com/s/y9l25ir50jgsa3r/1seeding.txt?dl=1"
        
        // Fetch data from 'pathURL' and put it in a the master data array
        do {
            let rawBracketData = try NSData(contentsOfURL: NSURL(string: pathURL)!, options: NSDataReadingOptions())
            rawDataString = NSString(data: rawBracketData, encoding: NSUTF8StringEncoding)! as String
        } catch {
            print(error)
            return false
        }
        
        
        if (rawDataString != "") {
            do {
                // Save file to phone
                try seedingFile.saveFile(string: rawDataString)
                
                //Separate by lines, then separate lines into the master data array
                let linesOfData = try seedingFile.getContentsOfFile().componentsSeparatedByString("\n")
                
                // Get year from first line
                self.year = linesOfData[0]
                
                currentYearLabel.text = "Data loaded from \(self.year) tournament"
                
                // Populate array from remaining lines
                for line in 1...(linesOfData.count-1) {
                    masterDataArray.append(linesOfData[line].componentsSeparatedByString("/"))
                }
                
                return true
            }
            catch {
                print(error)
                return false;
            }
        }
        else {
            return false
        }
    }
    
    
    func updateData(seedingFile: FileSaveHelper) -> Bool {
        
        // Local variables (we want these to be equal in the end)
        var currentSaveFile = ""
        var rawDataString = ""
        
        // Get the string of the current save file on the phone (we should have created one before if it didn't exist)
        do {
            currentSaveFile = try seedingFile.getContentsOfFile()
        }
        catch
        {
            print(error)
        }
        
        // Dropbox: 2015seedings.txt
        // Line information: [bracket region] / [regional seeding] / [team name] / [RPI ranking]
        let pathURL = "https://www.dropbox.com/s/y9l25ir50jgsa3r/1seeding.txt?dl=1"
        
        // Fetch data from 'pathURL' and put it in a the master data array
        do {
            let rawBracketData = try NSData(contentsOfURL: NSURL(string: pathURL)!, options: NSDataReadingOptions())
            rawDataString = NSString(data: rawBracketData, encoding: NSUTF8StringEncoding)! as String
        } catch {
            print(error)
        }
        
        // If the saved data and online data are different
        if currentSaveFile != rawDataString
        {
                do {
                    // Try to save to disk (long term)
                    try seedingFile.saveFile(string: rawDataString)

                    return true
                }
                catch {
                    print(error)
                    return false
                }
        }

        // If we made it here, we didn't find a difference between the online file and the one on the computer
        return false
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

    // MARK: TextField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // We update a variable so when user clicks "Close" we know which picker to close
        activeTF = textField
    }
    
    // MARK: UIPickerView Delegate
    
    // We only have one column in each picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // Our data depends on which picker we have, so let's determine that first
        var thisPickerArray : [[String]] = []
        
        switch pickerView {
        case cinderellaPicker:
            thisPickerArray = masterDataArray
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
        
        if(pickerView == cinderellaPicker) {
            // Cinderella has optional "None")
            return (thisPickerArray.count + 2)
        }
        else {
            return (thisPickerArray.count + 1)
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // Our data depends on which picker we have, so let's determine that first
        var thisPickerArray : [[String]] = []
        
        switch pickerView {
            case cinderellaPicker:
                thisPickerArray = masterDataArray
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
        if(pickerView == cinderellaPicker) {
            // If Sort by seed DESCENDING
            thisPickerArray = thisPickerArray.sort {Int($0[1]) > Int($1[1])}
        
            if row == 0 {
                return "None"
            }
            if row == 1 {
                return self.placeholder
            }
            else {
                // [Seed]. [Team Name]
                return "\(thisPickerArray[row-2][1]). \(thisPickerArray[row-2][2])"
            }
        }
        else {
            // If Sort by seed
            thisPickerArray = thisPickerArray.sort {Int($0[1]) < Int($1[1])}
            
            if row == 0 {
                return self.placeholder
            }
            else {
                // [Seed]. [Team Name]
                return "\(thisPickerArray[row-1][1]). \(thisPickerArray[row-1][2])"
            }
        }
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        // Our data depends on which picker we have, so let's determine that first
        var thisPickerTextField = UITextField()
        var thisPickerArray : [[String]] = []
        
        switch pickerView {
            
        case cinderellaPicker:
            thisPickerTextField = cinderellaTF
            thisPickerArray = masterDataArray
            
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
            winnerPicker.reloadAllComponents()
            
        case finalPicker2:
            thisPickerTextField = finalTwoTextField
            thisPickerArray = finalPicker2Helper()
            winnerPicker.reloadAllComponents()

        case winnerPicker:
            thisPickerTextField = winnerPickerTextField
            thisPickerArray = winnerPickerHelper()
            
        default:
            thisPickerTextField = winnerPickerTextField
            thisPickerArray = masterDataArray
        }
        
        if(pickerView == cinderellaPicker) {
            // Sort by seed DESCENDING
            thisPickerArray = thisPickerArray.sort {Int($0[1]) > Int($1[1])}
            
            //Assign value
            if row == 0 {
                thisPickerTextField.text = "None"
            }
            else if row == 1 {
                thisPickerTextField.text = self.placeholder
            }
            else {
                thisPickerTextField.text = thisPickerArray[row-2][2]
            }
            
        }
        else {
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
                        // Select row that is the seed of the team in the picker below
                        self.midwestPicker.selectRow(Int(thisPickerArray[row-1][1])!, inComponent: 0, animated: false)
                        finalPicker1.reloadAllComponents()
                    case 2:
                        westFinalTextField.text = teamName
                        // Select row that is the seed of the team in the picker below
                        self.westPicker.selectRow(Int(thisPickerArray[row-1][1])!, inComponent: 0, animated: false)
                        finalPicker1.reloadAllComponents()
                    default: break
                    }
                    
                    // If the team they picked to win is not the team winning champ (or the team from the other final)
                    if (winnerPickerTextField.text != teamName && winnerPickerTextField.text != finalTwoTextField.text) {
                        winnerPickerTextField.text = placeholder
                        self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
                    }
                }
                    
                // If this is the second final, we need to populate UPWARDS
                else if(pickerView == finalPicker2) {
                    //Get region of winner
                    switch Int(thisPickerArray[row-1][0])! {
                    case 3:
                        eastFinalTextField.text = teamName
                        // Select row that is the seed of the team in the picker below
                        self.eastPicker.selectRow(Int(thisPickerArray[row-1][1])!, inComponent: 0, animated: false)
                        finalPicker2.reloadAllComponents()
                    case 4:
                        southFinalTextField.text = teamName
                        // Select row that is the seed of the team in the picker below
                        self.southPicker.selectRow(Int(thisPickerArray[row-1][1])!, inComponent: 0, animated: false)
                        finalPicker2.reloadAllComponents()
                    default: break
                    }
                    
                    // If the team they picked to win is not the team winning champ (or the team from the other final)
                    if (winnerPickerTextField.text != teamName && winnerPickerTextField.text != finalOneTextField.text) {
                        winnerPickerTextField.text = placeholder
                        self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
                    }
                }
                
                // If this is a region winner, we need to make sure to recent the teams above
                else if(pickerView == midwestPicker) {
                    
                    // If the team they picked to win the midwest is not the team winning next (or the team from the west)
                    if (finalOneTextField.text != teamName && finalOneTextField.text != westFinalTextField.text) {
                        finalOneTextField.text = placeholder
                        self.finalPicker1.selectRow(0, inComponent: 0, animated: false)
                        winnerPicker.reloadAllComponents()
                    }
                }
                
                else if(pickerView == westPicker) {
                    
                    // If the team they picked to win the midwest is not the team winning next (or the team from the west)
                    if (finalOneTextField.text != teamName && finalOneTextField.text != midwestFinalTextField.text) {
                        finalOneTextField.text = placeholder
                        self.finalPicker1.selectRow(0, inComponent: 0, animated: false)
                        winnerPicker.reloadAllComponents()
                    }
                }
                
                else if(pickerView == southPicker) {
                    
                    // If the team they picked to win the midwest is not the team winning next (or the team from the west)
                    if (finalTwoTextField.text != teamName && finalTwoTextField.text != eastFinalTextField.text) {
                        finalTwoTextField.text = placeholder
                        self.finalPicker2.selectRow(0, inComponent: 0, animated: false)
                        winnerPicker.reloadAllComponents()
                    }
                }
                
                else if(pickerView == eastPicker) {
                    
                    // If the team they picked to win the midwest is not the team winning next (or the team from the west)
                    if (finalTwoTextField.text != teamName && finalTwoTextField.text != southFinalTextField.text) {
                        finalTwoTextField.text = placeholder
                        self.finalPicker2.selectRow(0, inComponent: 0, animated: false)
                        winnerPicker.reloadAllComponents()
                    }
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
    
    // MARK: Navigation/Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // Run the function below to fill out the whole
        let completedBracket = self.createButtonClicked()
        
        // This is the only place to go (for now)
        let tabDisplayView = segue.destinationViewController as! TabDisplayViewController
        
        // Pass the bracket to the tabDisplayView
        tabDisplayView.self.bracketData = completedBracket

        // If we have a random cinderella, tell the tabDisplay. We want to show the user with a pop up there
        if(cinderellaTF.text == self.placeholder) {
            tabDisplayView.self.randomCinder = true
        }
    }
    
    // MARK: Actions

    func createButtonClicked() -> BracketToDisplay {
        
        // When the button is clicked, we want to capture the user customization preferences
        let theseUserPrefs = UserSelectedPrefs(mwFinal: midwestFinalTextField.text!, wFinal: westFinalTextField.text!, sFinal: southFinalTextField.text!, eFinal: eastFinalTextField.text!, final1: finalOneTextField.text!, final2: finalTwoTextField.text!, winner: winnerPickerTextField.text!, upsets: upsetsSlider.value, cinderella: cinderellaTF.text!)
        
        // Then we create the bracket, starting by sending the raw data over to the solver
        let bracket = BracketSolver(masterArray: masterDataArray, mwArray: midwestRegionArray, wArray: westRegionArray, sArray: southRegionArray, eArray: eastRegionArray, ph: placeholder)
        
        // Using the user preferences we fill out the bracket
        bracket.fillOutBracket(theseUserPrefs)
        
        
        return bracket.completeBracket
    }
    
    @IBAction func resetButtonClicked(sender: AnyObject) {
        
        // Pop up to confirm reset
        let alert = UIAlertController(title: "Reset", message: "Reset back to Default Settings?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // if they want to reset
        let resetAction = UIAlertAction(title: "Reset", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            
            // Change the text back to the placeholder
            self.self.midwestFinalTextField.text = self.placeholder
            self.westFinalTextField.text = self.placeholder
            self.southFinalTextField.text = self.placeholder
            self.eastFinalTextField.text = self.placeholder
            self.finalOneTextField.text = self.placeholder
            self.finalTwoTextField.text = self.placeholder
            self.winnerPickerTextField.text = self.placeholder
            self.cinderellaTF.text = "None"
            
            // Spin the pickers back to the top
            self.midwestPicker.selectRow(0, inComponent: 0, animated: false)
            self.westPicker.selectRow(0, inComponent: 0, animated: false)
            self.southPicker.selectRow(0, inComponent: 0, animated: false)
            self.eastPicker.selectRow(0, inComponent: 0, animated: false)
            self.finalPicker1.selectRow(0, inComponent: 0, animated: false)
            self.finalPicker2.selectRow(0, inComponent: 0, animated: false)
            self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
            self.cinderellaPicker.selectRow(0, inComponent: 0, animated: false)
            
            // Sliders to the middle
            self.upsetsSlider.value = 0.5
            
        }
        
        // for cancel we won't do anything
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
        
        // Add actions to alert and show
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        alert.preferredAction = resetAction
        presentViewController(alert, animated: true) { () -> Void in }
    }

    // Function for the done button on the pickerView
    func donePicker() {
        // Close the picker for the active text field (set in DidBeginEdit)
        activeTF.resignFirstResponder()
    }
    
    // MARK: Outlets and Connections
    @IBOutlet weak var winnerPickerTextField: UITextField!
    @IBOutlet weak var midwestFinalTextField: UITextField!
    @IBOutlet weak var westFinalTextField: UITextField!
    @IBOutlet weak var southFinalTextField: UITextField!
    @IBOutlet weak var eastFinalTextField: UITextField!
    @IBOutlet weak var finalOneTextField: UITextField!
    @IBOutlet weak var finalTwoTextField: UITextField!
    @IBOutlet weak var createBracketButton: UIButton!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var cinderellaTF: UITextField!
    @IBOutlet weak var upsetsSlider: UISlider!
    
    @IBOutlet weak var currentYearLabel: UILabel!
}