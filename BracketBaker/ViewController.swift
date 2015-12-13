//
//  ViewController.swift
//  BracketBaker
//
//  Created by Jason Gaare on 12/7/15.
//  Copyright © 2015 Jason Gaare. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    // MARK: Global Variables
    
    var dataLoaded = false
    
    var masterDataArray : [[String]] = []
    
    var southRegionArray : [[String]] = []
    var eastRegionArray : [[String]] = []
    var westRegionArray : [[String]] = []
    var midwestRegionArray : [[String]] = []
    
    // MARK: View Load/Unload Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // *----1----*
        // We want to ensure we have a file on device with the bracket seedings
        let seedingFile = FileSaveHelper(fileName: "currentSeedings", fileExtension: .TXT, subDirectory: "SaveFiles", directory: .DocumentDirectory)
        // If we don't have the file, create it
        if !seedingFile.fileExists {
            do {
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
            
            populateInitialArrays()
            
            let testPicker = UIPickerView()
            testPicker.delegate = self
            winnerPickerTextField.inputView = testPicker
            
            // Made it!
            print("Successful Load.")
        }
            
        // If we couldn't find data, then this app is worthless
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
            let alert = UIAlertController(title: "No Data", message: "Functionality limited due to lack of data. Try again with valid network connection.", preferredStyle: UIAlertControllerStyle.Alert)
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
                    southRegionArray.append(ix)
                case 2:
                    eastRegionArray.append(ix)
                case 3:
                    westRegionArray.append(ix)
                case 4:
                    midwestRegionArray.append(ix)
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
        return (masterDataArray.count + 1)
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            return "Random"
        }
        else {
            return masterDataArray[row-1][2]
        }
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        //Assign value
        if row == 0 {
            winnerPickerTextField.text = "Random"
        }
        else {
             winnerPickerTextField.text = masterDataArray[row-1][2]
        }
        
        // Close the picker
        winnerPickerTextField.resignFirstResponder()
    }

    // MARK: Outlets and Connections
    
    @IBOutlet weak var winnerPickerTextField: UITextField!
    
    
}