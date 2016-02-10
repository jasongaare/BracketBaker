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
    var labelButton = UIBarButtonItem()
    
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
    var textEnteringTF : String = ""
    var rowEnteringTF : Int = 0
    var selectedRow : Int = 0
    var pickerArrayEnteringTF : [[String]] = []
    
    // MARK:- View Load/Unload Functions
    
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
                
                // Separate by lines, then separate lines into the master data array
                let linesOfData = currentFileContents.componentsSeparatedByString("\n")
                
                // Data file should have year (1 line) and info for 64 teams (64 lines)
                if(linesOfData.count == 65) {
                    // Get year from first line
                    self.year = linesOfData[0]
                
                    currentYearLabel.text = "Data loaded from \(self.year) tournament"
                
                    // Populate array from remaining lines
                    for line in 1...(linesOfData.count-1) {
                        masterDataArray.append(linesOfData[line].componentsSeparatedByString("/"))
                    }
                
                    dataLoaded = true
                }
                else {
                    dataLoaded = false
                }
                
                
                // Let's look online in the background, to see if we need to update a new file
                
                //* BACKGROUND
                //* ___________
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                    
                    // Run retreive data, will return true if we updated the file
                    let updateFile = self.updateData(seedingFile)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if (updateFile) {
                            
                            let alert = UIAlertController(title: "New data", message: "Updated tournament information found online. Data will now refresh.", preferredStyle: UIAlertControllerStyle.Alert)
                            let rAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                                
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
            
            /*
             *  CREATE THE TOOL BAR ON TOP OF THE PICKERS
             */
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.Default
            toolBar.translucent = false
            toolBar.barTintColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            toolBar.tintColor = UIColor(red: 238/255, green: 129/255, blue: 47/255, alpha: 1)
            toolBar.sizeToFit()
            
            // Close Button
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicker")
            // space after button
            let spaceButtonL = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            // Label for title
            self.labelButton = UIBarButtonItem(title: "Label", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            // space after button
            self.labelButton.tintColor = UIColor(red: 31/255, green: 71/255, blue: 131/255, alpha: 1)
            self.labelButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 17)!], forState: .Normal)
            
            let spaceButtonR = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            // Close Button
            let selectButton = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.Plain, target: self, action: "selectPicker")
            
            toolBar.setItems([cancelButton, spaceButtonL, self.labelButton, spaceButtonR, selectButton], animated: false)
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
            let alert = UIAlertController(title: "No Data Found", message: "Something went wrong. Please terminate the app, check your network connection, and try again.", preferredStyle: UIAlertControllerStyle.Alert)
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
        
        // Get the team when we clicked in case user hits cancel
        textEnteringTF = textField.text!
        
        // Make sure we know which TF we are in later
        activeTF = textField
        
        // Get the selected row in the picker in case we need to go back on a cancel
        switch textField {
        case cinderellaTF :
            rowEnteringTF = cinderellaPicker.selectedRowInComponent(0)
            self.labelButton.title = "Cinderella Team"
        case midwestFinalTextField:
            rowEnteringTF = midwestPicker.selectedRowInComponent(0)
            self.labelButton.title = "Midwest Winner"
        case westFinalTextField:
            rowEnteringTF = westPicker.selectedRowInComponent(0)
            self.labelButton.title = "West Winner"
        case southFinalTextField:
            rowEnteringTF = southPicker.selectedRowInComponent(0)
            self.labelButton.title = "South Winner"
        case eastFinalTextField:
            rowEnteringTF = eastPicker.selectedRowInComponent(0)
            self.labelButton.title = "East Winner"
        case finalOneTextField:
            rowEnteringTF = finalPicker1.selectedRowInComponent(0)
            self.labelButton.title = "Midwest/West Winner"
        case finalTwoTextField:
            rowEnteringTF = finalPicker2.selectedRowInComponent(0)
            self.labelButton.title = "East/South Winner"
        case winnerPickerTextField:
            rowEnteringTF = winnerPicker.selectedRowInComponent(0)
            self.labelButton.title = "Overall Winner"
        default:
            rowEnteringTF = 0
            self.labelButton.title = ""
        }
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
                // TODO: Figure out why this if statement is neccesary
                if(thisPickerArray.count >= row) {
                                    // [Seed]. [Team Name]
                    return "\(thisPickerArray[row-1][1]). \(thisPickerArray[row-1][2])"
                }
                else {
                    return ""
                }
            }
        }
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        // This helps in our refresh pickers function
        self.selectedRow = row
        
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
            
        case eastPicker:
            thisPickerTextField = eastFinalTextField
            thisPickerArray = eastSorted
            
        case westPicker:
            thisPickerTextField = westFinalTextField
            thisPickerArray = westSorted
            
        case midwestPicker:
            thisPickerTextField = midwestFinalTextField
            thisPickerArray = midwestSorted
            
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
            thisPickerArray = winnerPickerHelper()
        }
        

        
        if(pickerView == cinderellaPicker) {
            // Sort by seed DESCENDING
            thisPickerArray = thisPickerArray.sort {Int($0[1]) > Int($1[1])}

                    pickerArrayEnteringTF = thisPickerArray
            
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
            
                    pickerArrayEnteringTF = thisPickerArray
            
            //Assign value
            if row == 0 {
                thisPickerTextField.text = self.placeholder
            }
            else {
                let teamName = thisPickerArray[row-1][2]
                thisPickerTextField.text = teamName
            }
        }
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
    
    
    /*
     *  Basically here we want to make sure that we don't have any conflicts before we create
     *  the bracket, so we need to refresh the options after each user decision so they cannot
     *  select a team that does not make sense logically
     */
    
    func refreshAllPickers() {
        
        
        
        // This has already been updated by pickerView(didSelectRow)
        let teamName = self.activeTF.text!
        let row = self.selectedRow
        var thisPickerArray = self.pickerArrayEnteringTF
        var semiPickerArray : [[String]] = []

        
        switch activeTF {
            
            // The cinderella picker is on an island, so we don't need to do anything
        case cinderellaTF: break
            
            // For the midwest final we need to remove all non-selected teams from
            // the picker for final one
        case midwestFinalTextField:
            self.midwestPicker.reloadAllComponents()
            
            // If the team they picked to win the midwest is not the team winning next (or the team from the west)
            if (finalOneTextField.text != teamName && finalOneTextField.text != westFinalTextField.text) {
                finalOneTextField.text = placeholder
                self.finalPicker1.selectRow(0, inComponent: 0, animated: false)
                
                if(winnerPickerTextField.text != teamName && winnerPickerTextField.text != finalTwoTextField.text) {
                    winnerPickerTextField.text = placeholder
                    self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
                }
            }
            // If we didn't refresh the final 1 picker, we need to make sure it is spun to the correct row
            else {
                semiPickerArray = finalPicker1Helper()
                // Sort like the picker
                semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
                
                // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
                var semiRow = 1
                for item in semiPickerArray {
                    // If the name of the row matches the team
                    if (item[2] == finalOneTextField.text!) {
                        self.finalPicker1.selectRow(semiRow, inComponent: 0, animated: false)
                        break
                    }
                    semiRow++
                }
            }
            
            
        case westFinalTextField:
            self.westPicker.reloadAllComponents()
            
            // If the team they picked to win the midwest is not the team winning next (or the team from the west)
            if (finalOneTextField.text != teamName && finalOneTextField.text != midwestFinalTextField.text) {
                finalOneTextField.text = placeholder
                self.finalPicker1.selectRow(0, inComponent: 0, animated: false)

                if(winnerPickerTextField.text != teamName && winnerPickerTextField.text != finalTwoTextField.text) {
                    winnerPickerTextField.text = placeholder
                    self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
                }
            }
            else {
                semiPickerArray = finalPicker1Helper()
                // Sort like the picker
                semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
                
                // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
                var semiRow = 1
                for item in semiPickerArray {
                    // If the name of the row matches the team
                    if (item[2] == finalOneTextField.text!) {
                        self.finalPicker1.selectRow(semiRow, inComponent: 0, animated: false)
                        break
                    }
                    semiRow++
                }
            }
            
            
        case eastFinalTextField:
            self.eastPicker.reloadAllComponents()
            
            // If the team they picked to win the midwest is not the team winning next (or the team from the west)
            if (finalTwoTextField.text != teamName && finalTwoTextField.text != southFinalTextField.text) {
                finalTwoTextField.text = placeholder
                self.finalPicker2.selectRow(0, inComponent: 0, animated: false)

                if(winnerPickerTextField.text != teamName && winnerPickerTextField.text != finalOneTextField.text) {
                    winnerPickerTextField.text = placeholder
                    self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
                }
            }
            else {
                semiPickerArray = finalPicker2Helper()
                // Sort like the picker
                semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
                
                // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
                var semiRow = 1
                for item in semiPickerArray {
                    // If the name of the row matches the team
                    if (item[2] == finalTwoTextField.text!) {
                        self.finalPicker2.selectRow(semiRow, inComponent: 0, animated: false)
                        break
                    }
                    semiRow++
                }
            }
            
            
        case southFinalTextField:
            self.southPicker.reloadAllComponents()
            
            // If the team they picked to win the midwest is not the team winning next (or the team from the west)
            if (finalTwoTextField.text != teamName && finalTwoTextField.text != eastFinalTextField.text) {
                finalTwoTextField.text = placeholder
                self.finalPicker2.selectRow(0, inComponent: 0, animated: false)

                if(winnerPickerTextField.text != teamName && winnerPickerTextField.text != finalOneTextField.text) {
                    winnerPickerTextField.text = placeholder
                    self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
                }
            }
            else {
                semiPickerArray = finalPicker2Helper()
                // Sort like the picker
                semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
                
                // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
                var semiRow = 1
                for item in semiPickerArray {
                    // If the name of the row matches the team
                    if (item[2] == finalTwoTextField.text!) {
                        self.finalPicker2.selectRow(semiRow, inComponent: 0, animated: false)
                        break
                    }
                    semiRow++
                }
            }
            
            
        // If we've selected the final 1 team, we need to populate upwards to the games prior to this
        case finalOneTextField:
            
            // If the user picked a team (NOT the placeholder)
            if (row > 0) {
                // FIXME: There's something fishy going on if we pick the team selected in another region
                if(teamName != midwestFinalTextField.text! && teamName != westFinalTextField.text!) {
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
                }
            }
            
            semiPickerArray = finalPicker1Helper()
            // Sort like the picker
            semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
            
            // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
            var semiRow = 1
            for item in semiPickerArray {
                // If the name of the row matches the team
                if (item[2] == finalOneTextField.text!) {
                    self.finalPicker1.selectRow(semiRow, inComponent: 0, animated: false)
                    break
                }
                semiRow++
            }

            
            // If the team they picked to win is not the team winning champ (or the team from the other final)
            if (winnerPickerTextField.text != teamName && winnerPickerTextField.text != finalTwoTextField.text) {
                winnerPickerTextField.text = placeholder
                self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
            }
            
            // Call pickerView(titleforRow)
            self.finalPicker1.reloadAllComponents()
            
        case finalTwoTextField:
            
            // If the user picked a team (NOT the placeholder)
            if (row > 0) {
                // FIXME: Ditto
                if(teamName != eastFinalTextField.text! && teamName != southFinalTextField.text!) {
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
                }
            }
            
            // Fix ourself
            semiPickerArray = finalPicker2Helper()
            // Sort like the picker
            semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
            
            // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
            var semiRow = 1
            for item in semiPickerArray {
                // If the name of the row matches the team
                if (item[2] == finalTwoTextField.text!) {
                    self.finalPicker2.selectRow(semiRow, inComponent: 0, animated: false)
                    break
                }
                semiRow++
            }

            
            // If the team they picked to win is not the team winning champ (or the team from the other final)
            if (winnerPickerTextField.text != teamName && winnerPickerTextField.text != finalOneTextField.text) {
                winnerPickerTextField.text = placeholder
                self.winnerPicker.selectRow(0, inComponent: 0, animated: false)
            }
        
        
        case winnerPickerTextField:

            // If the user picked a team (NOT the placeholder)
            if (row > 0) {
                // Get region of winner
                switch Int(thisPickerArray[row-1][0])! {
                case 1:
                    midwestFinalTextField.text = teamName
                    self.midwestPicker.selectRow(Int(thisPickerArray[row-1][1])!, inComponent: 0, animated: false)
                    
                    finalOneTextField.text = teamName
                    semiPickerArray = finalPicker1Helper()
                    // Sort like the picker
                    semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
                        
                    // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
                    var semiRow = 1
                    for item in semiPickerArray {
                        // If the name of the row matches the team
                        if (item[2] == teamName) {
                            self.finalPicker1.selectRow(semiRow, inComponent: 0, animated: false)
                            break
                        }
                        semiRow++
                    }
                    
                case 2:
                    westFinalTextField.text = teamName
                    self.westPicker.selectRow(Int(thisPickerArray[row-1][1])!, inComponent: 0, animated: false)
                    
                    finalOneTextField.text = teamName
                    semiPickerArray = finalPicker1Helper()
                    // Sort like the picker
                    semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
                    
                    // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
                    var semiRow = 1
                    for item in semiPickerArray {
                        // If the name of the row matches the team
                        if (item[2] == teamName) {
                            self.finalPicker1.selectRow(semiRow, inComponent: 0, animated: false)
                            break
                        }
                        semiRow++
                    }
                case 3:
                    eastFinalTextField.text = teamName
                    self.eastPicker.selectRow(Int(thisPickerArray[row-1][1])!, inComponent: 0, animated: false)
                    
                    finalTwoTextField.text = teamName
                    semiPickerArray = finalPicker2Helper()
                    // Sort like the picker
                    semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
                    
                    // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
                    var semiRow = 1
                    for item in semiPickerArray {
                        // If the name of the row matches the team
                        if (item[2] == teamName) {
                            self.finalPicker2.selectRow(semiRow, inComponent: 0, animated: false)
                            break
                        }
                        semiRow++
                    }
                case 4:
                    southFinalTextField.text = teamName
                    self.southPicker.selectRow(Int(thisPickerArray[row-1][1])!, inComponent: 0, animated: false)
                    
                    finalTwoTextField.text = teamName
                    semiPickerArray = finalPicker2Helper()
                    // Sort like the picker
                    semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
                    
                    // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
                    var semiRow = 1
                    for item in semiPickerArray {
                        // If the name of the row matches the team
                        if (item[2] == teamName) {
                            self.finalPicker2.selectRow(semiRow, inComponent: 0, animated: false)
                            break
                        }
                        semiRow++
                    }
                default : break
                }
            }
            
        default:
            break
        }
        
        
        // ACTUALLY WINNER
        semiPickerArray = winnerPickerHelper()
        // Sort like the picker
        semiPickerArray = semiPickerArray.sort {Int($0[1]) < Int($1[1])}
        
        // Set semirow to 1, and find the row we should select (accounting for the placeholder at row zero
        var semiRow = 1
        for item in semiPickerArray {
            // If the name of the row matches the team
            if (item[2] == winnerPickerTextField.text!) {
                self.winnerPicker.selectRow(semiRow, inComponent: 0, animated: false)
                break
            }
            semiRow++
        }
        
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
    func cancelPicker() {
        
        
        // Change team in text field back to previous team (when user clicked)
        activeTF.text = self.textEnteringTF
        
        // Roll back the picker to that row
        switch activeTF {
        case cinderellaTF:
            self.cinderellaPicker.selectRow(self.rowEnteringTF, inComponent: 0, animated: false)
        case midwestFinalTextField:
            self.midwestPicker.selectRow(self.rowEnteringTF, inComponent: 0, animated: false)
        case westFinalTextField:
            self.westPicker.selectRow(self.rowEnteringTF, inComponent: 0, animated: false)
        case eastFinalTextField:
            self.eastPicker.selectRow(self.rowEnteringTF, inComponent: 0, animated: false)
        case southFinalTextField:
            self.southPicker.selectRow(self.rowEnteringTF, inComponent: 0, animated: false)
        case finalOneTextField:
            self.finalPicker1.selectRow(self.rowEnteringTF, inComponent: 0, animated: false)
        case finalTwoTextField:
            self.finalPicker2.selectRow(self.rowEnteringTF, inComponent: 0, animated: false)
        case winnerPickerTextField:
            self.winnerPicker.selectRow(self.rowEnteringTF, inComponent: 0, animated: false)
        default:
            break
        }
        
        // Close the picker for the active text field (set in DidBeginEdit)
        activeTF.resignFirstResponder()
    }
    
    func selectPicker() {
        
        // Update possible teams
        self.refreshAllPickers()
        
        activeTF.resignFirstResponder()
    }
    
    
    // MARK:- Outlets and Connections
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