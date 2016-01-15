//
//  TabDisplayChampsContoller.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/11/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class TabDisplayChampsContoller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Let's get our parent view controller, that's where our data is sitting
        let tdvc = self.tabBarController as! TabDisplayViewController
        
        // Get the data
        let teamArray = tdvc.bracketData.champs
        
        // Display the winners on the labels
        mwFinalLabel.text = "\(teamArray[0][1]). \(teamArray[0][2])"
        wFinalLabel.text = "\(teamArray[1][1]). \(teamArray[1][2])"
        eFinalLabel.text = "\(teamArray[2][1]). \(teamArray[2][2])"
        sFinalLabel.text = "\(teamArray[3][1]). \(teamArray[3][2])"
        Final1Label.text = "\(teamArray[4][1]). \(teamArray[4][2])"
        Final2Label.text = "\(teamArray[5][1]). \(teamArray[5][2])"
        ChampLabel.text = teamArray[6][2]
        
        // We need to let the view know where these labels are,
        // that way we can draw the lines under the teams to make
        // the brackets
        myBracketDisplay.mwFinal = mwFinalLabel
        myBracketDisplay.wFinal = wFinalLabel
        myBracketDisplay.eFinal = eFinalLabel
        myBracketDisplay.sFinal = sFinalLabel
        myBracketDisplay.final1 = Final1Label
        myBracketDisplay.final2 = Final2Label
        myBracketDisplay.champion = ChampLabel
    }
    
    
    // MARK: Outlets
    
    @IBOutlet weak var mwFinalLabel: UILabel!
    @IBOutlet weak var wFinalLabel: UILabel!
    @IBOutlet weak var eFinalLabel: UILabel!
    @IBOutlet weak var sFinalLabel: UILabel!
    
    @IBOutlet weak var Final1Label: UILabel!
    @IBOutlet weak var Final2Label: UILabel!
    @IBOutlet weak var ChampLabel: UILabel!
    
    
    @IBOutlet weak var myBracketDisplay: TabDisplayChamps!
    
}
