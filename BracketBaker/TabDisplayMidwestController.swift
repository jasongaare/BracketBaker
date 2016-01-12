//
//  TabDisplayMidwestController.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/11/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class TabDisplayMidwestController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do stuff here
        print("Hello from midwest")

        let tdvc = self.tabBarController as! TabDisplayViewController
        let midwestArray = tdvc.bracketData.midwest
        
        winner1.text = "\(midwestArray[0][2])"
        winner2.text = "\(midwestArray[1][2])"
        winner3.text = "\(midwestArray[2][2])"
        winner4.text = "\(midwestArray[3][2])"
        winner5.text = "\(midwestArray[4][2])"
        winner6.text = "\(midwestArray[5][2])"
        winner7.text = "\(midwestArray[6][2])"
        winner8.text = "\(midwestArray[7][2])"

        let canvas = super.view as! TabDisplayMidwest
        canvas.team1 = winner1
        canvas.team2 = winner2
        canvas.team3 = winner3
        canvas.team4 = winner4
        canvas.team5 = winner5
        canvas.team6 = winner6
        canvas.team7 = winner7
        canvas.team8 = winner8
        
    }
    

    
    // MARK : Outlets (galore!)
    @IBOutlet weak var winner1: UILabel!
    @IBOutlet weak var winner2: UILabel!
    @IBOutlet weak var winner3: UILabel!
    @IBOutlet weak var winner4: UILabel!
    @IBOutlet weak var winner5: UILabel!
    @IBOutlet weak var winner6: UILabel!
    @IBOutlet weak var winner7: UILabel!
    @IBOutlet weak var winner8: UILabel!

    
    
}
