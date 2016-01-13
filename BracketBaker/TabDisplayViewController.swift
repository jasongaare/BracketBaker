//
//  TabDisplayViewController.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/12/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class TabDisplayViewController: UITabBarController {

    var bracketData : BracketToDisplay
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Your Bracket"
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.bracketData = BracketToDisplay(mw: [], w: [], e: [], s: [], c: [])
        
        super.init(coder: aDecoder)
    }
}
