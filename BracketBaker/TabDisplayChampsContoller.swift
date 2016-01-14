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
        
        mwFinalLabel.text = teamArray[0][2]
        wFinalLabel.text = teamArray[1][2]
        eFinalLabel.text = teamArray[2][2]
        sFinalLabel.text = teamArray[3][2]
        Final1Label.text = teamArray[4][2]
        Final2Label.text = teamArray[5][2]
        ChampLabel.text = teamArray[6][2]
    }
    
    
    // MARK: Outlets
    
    @IBOutlet weak var mwFinalLabel: UILabel!
    @IBOutlet weak var wFinalLabel: UILabel!
    @IBOutlet weak var eFinalLabel: UILabel!
    @IBOutlet weak var sFinalLabel: UILabel!
    
    @IBOutlet weak var Final1Label: UILabel!
    @IBOutlet weak var Final2Label: UILabel!
    @IBOutlet weak var ChampLabel: UILabel!
    
    
}
