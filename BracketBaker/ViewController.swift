//
//  ViewController.swift
//  BracketBaker
//
//  Created by Jason Gaare on 12/7/15.
//  Copyright © 2015 Jason Gaare. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    var rawDataString : NSString = ""
    var testPickerData = ["Check", "One", "Two"]
    
    
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
        
        
        // Made it!
        print("Successful Load.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func retreiveDatafromURL() -> Bool {
        
        // Dropbox: 2015seedings.txt
        // Line information: [bracket region] / [regional seeding] / [team name] / [RPI ranking]
        let pathURL = "https://www.dropbox.com/s/wzempl4ani1gt9c/2015seeding.txt?dl=1"
        
        // Fetch data from 'pathURL' and put it in a string
        do {
            let rawBracketData = try NSData(contentsOfURL: NSURL(string: pathURL)!, options: NSDataReadingOptions())
            self.rawDataString = NSString(data: rawBracketData, encoding: NSUTF8StringEncoding)!
        } catch {
            print(error)
        }
        
        
        return true
    }
    
    
    // MARK: UIPickerView Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return testPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return testPickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        //Assign value
        winnerPickerTextField.text = testPickerData[row]
        
        // Close the picker
        winnerPickerTextField.resignFirstResponder()
    }

    // MARK: Outlets and Connections
    
    @IBOutlet weak var winnerPickerTextField: UITextField!
    
    
}