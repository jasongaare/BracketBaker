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

        let canvas = super.view as! TabDisplayMidwest
        canvas.team1 = winner1
        canvas.team2 = winner2
    }
    

    
    // MARK : Outlets (galore!)
    @IBOutlet weak var winner1: UILabel!
    @IBOutlet weak var winner2: UILabel!

    
    
}
