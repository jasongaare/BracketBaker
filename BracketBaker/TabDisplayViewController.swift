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
        
        // Change color of tool bar
        self.tabBar.barTintColor = UIColor(red: 235/256, green: 235/256, blue: 235/256, alpha: 1)
        self.tabBar.tintColor = UIColor(red: 31/255, green: 101/255, blue: 171/255, alpha: 1)
        self.tabBar.translucent = false
        
 

        
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
