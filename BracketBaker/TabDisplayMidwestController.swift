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
        winner1.text = "\(teamArray[0][1]). \(teamArray[0][2])"
        winner2.text = "\(teamArray[1][1]). \(teamArray[1][2])"
        winner3.text = "\(teamArray[2][1]). \(teamArray[2][2])"
        winner4.text = "\(teamArray[3][1]). \(teamArray[3][2])"
        winner5.text = "\(teamArray[4][1]). \(teamArray[4][2])"
        winner6.text = "\(teamArray[5][1]). \(teamArray[5][2])"
        winner7.text = "\(teamArray[6][1]). \(teamArray[6][2])"
        winner8.text = "\(teamArray[7][1]). \(teamArray[7][2])"
        winner9.text = "\(teamArray[8][1]). \(teamArray[8][2])"
        winner10.text = "\(teamArray[9][1]). \(teamArray[9][2])"
        winner11.text = "\(teamArray[10][1]). \(teamArray[10][2])"
        winner12.text = "\(teamArray[11][1]). \(teamArray[11][2])"
        winner13.text = "\(teamArray[12][1]). \(teamArray[12][2])"
        winner14.text = "\(teamArray[13][1]). \(teamArray[13][2])"
        winner15.text = "\(teamArray[14][1]). \(teamArray[14][2])"


        // We need to let the view know where these labels are, 
        // that way we can draw the lines under the teams to make
        // the brackets
        myBracketDisplay.team1 = winner1
        myBracketDisplay.team2 = winner2
        myBracketDisplay.team3 = winner3
        myBracketDisplay.team4 = winner4
        myBracketDisplay.team5 = winner5
        myBracketDisplay.team6 = winner6
        myBracketDisplay.team7 = winner7
        myBracketDisplay.team8 = winner8
        myBracketDisplay.team9 = winner9
        myBracketDisplay.team10 = winner10
        myBracketDisplay.team11 = winner11
        myBracketDisplay.team12 = winner12
        myBracketDisplay.team13 = winner13
        myBracketDisplay.team14 = winner14
        myBracketDisplay.team15 = winner15
        
        
        // Make it scrollable
        bracketScroll.contentSize = myBracketDisplay.bounds.size
        
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
    
    @IBOutlet weak var bracketScroll: UIScrollView!
    @IBOutlet weak var myBracketDisplay: TabDisplayRegion!

    
    
}
