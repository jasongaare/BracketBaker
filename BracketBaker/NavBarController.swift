//
//  NavBarController.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/21/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class NavBarController: UINavigationController, UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bb_Blue = UIColor(red: 31/256, green: 101/256, blue: 171/256, alpha: 1)
        let bb_Orange = UIColor(red: 238/256, green: 129/256, blue: 47/256, alpha: 1)
        let bb_font = UIFont(name: "Optima-Bold", size: 22.0)
        
        navBar.barTintColor = bb_Blue
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: bb_Orange, NSFontAttributeName: bb_font!]
        
        // For the back buttons
        navBar.tintColor = UIColor.whiteColor()
        
    }
    

    
    @IBOutlet weak var navBar: UINavigationBar!
    
}
