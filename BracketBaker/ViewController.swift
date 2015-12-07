//
//  ViewController.swift
//  BracketBaker
//
//  Created by Jason Gaare on 12/7/15.
//  Copyright © 2015 Jason Gaare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var rawDataString : NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Retreive current bracket data
        if retreiveData() {
            print("Data loaded.")
        }
        
        // Made it!
        print("Successful Load.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func retreiveData() -> Bool {
        
        // Dropbox: 2015seedings.txt
        let pathURL = "https://www.dropbox.com/s/j193land2f9l23p/seeding.txt?dl=1"
        
        // Fetch data from 'pathURL' and put it in a string
        do {
            let rawBracketData = try NSData(contentsOfURL: NSURL(string: pathURL)!, options: NSDataReadingOptions())
            self.rawDataString = NSString(data: rawBracketData, encoding: NSUTF8StringEncoding)!
        } catch {
            print(error)
        }
        
        
        return true
    }

}