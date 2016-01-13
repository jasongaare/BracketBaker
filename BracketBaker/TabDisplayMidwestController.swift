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

        // Let's get our parent view controller, that's where our data is sitting
        let tdvc = self.tabBarController as! TabDisplayViewController
        
        // Get the data
        let teamArray = tdvc.bracketData.midwest
        
        // Display the winners on the labels
        winner1.text = "\(teamArray[0][2])"
        winner2.text = "\(teamArray[1][2])"
        winner3.text = "\(teamArray[2][2])"
        winner4.text = "\(teamArray[3][2])"
        winner5.text = "\(teamArray[4][2])"
        winner6.text = "\(teamArray[5][2])"
        winner7.text = "\(teamArray[6][2])"
        winner8.text = "\(teamArray[7][2])"
        winner9.text = "\(teamArray[8][2])"
        winner10.text = "\(teamArray[9][2])"
        winner11.text = "\(teamArray[10][2])"
        winner12.text = "\(teamArray[11][2])"
        winner13.text = "\(teamArray[12][2])"
        winner14.text = "\(teamArray[13][2])"
        winner15.text = "\(teamArray[14][2])"

        // We need to let the view know where these labels are, 
        // that way we can draw the lines under the teams to make
        // the brackets
        
        let canvas = super.view as! TabDisplayMidwest
        canvas.team1 = winner1
        canvas.team2 = winner2
        canvas.team3 = winner3
        canvas.team4 = winner4
        canvas.team5 = winner5
        canvas.team6 = winner6
        canvas.team7 = winner7
        canvas.team8 = winner8
        canvas.team9 = winner9
        canvas.team10 = winner10
        canvas.team11 = winner11
        canvas.team12 = winner12
        canvas.team13 = winner13
        canvas.team14 = winner14
        canvas.team15 = winner15
        
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
    @IBOutlet weak var winner9: UILabel!
    @IBOutlet weak var winner10: UILabel!
    @IBOutlet weak var winner11: UILabel!
    @IBOutlet weak var winner12: UILabel!
    @IBOutlet weak var winner13: UILabel!
    @IBOutlet weak var winner14: UILabel!
    @IBOutlet weak var winner15: UILabel!

    
    
}
