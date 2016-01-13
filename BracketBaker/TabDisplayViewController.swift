//
//  TabDisplayViewController.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/12/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class TabDisplayViewController: UITabBarController, UIGestureRecognizerDelegate {

    var bracketData : BracketToDisplay
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title that nav bar!
        self.title = "Your Bracket"
        
        // Set up gesture delegate
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    // Disable the back swipe to get to the customize page.
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.bracketData = BracketToDisplay(mw: [], w: [], e: [], s: [], c: [])
        
        super.init(coder: aDecoder)
    }
}
