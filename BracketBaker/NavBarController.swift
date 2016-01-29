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

        let bb_Orange = UIColor(red: 240/256, green: 131/256, blue: 49/256, alpha: 1)
        let bb_font22 = UIFont(name: "Optima-Bold", size: 22.0)
        
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: bb_Orange, NSFontAttributeName: bb_font22!]
        
        // For the back buttons
        navBar.tintColor = UIColor.whiteColor()
    }
    

    
    @IBOutlet weak var navBar: UINavigationBar!
    
}
