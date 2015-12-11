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
    
    var masterDataArray : [[String]] = []
    
    var southRegionArray : [[String]] = []
    var eastRegionArray : [[String]] = []
    var westRegionArray : [[String]] = []
    var midwestRegionArray : [[String]] = []
    
    // MARK: View Load/Unload Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Retreive current bracket data
        if retreiveDatafromURL() {
            print("Data loaded.")
        }
        
        let testPicker = UIPickerView()
        testPicker.delegate = self
        
        winnerPickerTextField.inputView = testPicker
        
        populateInitialArrays()
        
        print(midwestRegionArray[1][2])
        print(westRegionArray[1][2])
        
        
        // Made it!
        print("Successful Load.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Data Manipulation
    
    func retreiveDatafromURL() -> Bool {
        
        // Dropbox: 2015seedings.txt
        // Line information: [bracket region] / [regional seeding] / [team name] / [RPI ranking]
        let pathURL = "https://www.dropbox.com/s/wzempl4ani1gt9c/2015seeding.txt?dl=1"
        
        // Fetch data from 'pathURL' and put it in a the master data array
        do {
            
            let rawBracketData = try NSData(contentsOfURL: NSURL(string: pathURL)!, options: NSDataReadingOptions())
            let rawDataString = NSString(data: rawBracketData, encoding: NSUTF8StringEncoding)!
            
            //Separate by lines, then separate lines into the master data array
            let linesOfData = rawDataString.componentsSeparatedByString("\n")
            for ix in linesOfData {
                masterDataArray.append(ix.componentsSeparatedByString("/") as [String])
            }
            
        } catch {
            print(error)
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