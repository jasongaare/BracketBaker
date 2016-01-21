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
        
        let bb_Blue = UIColor(red: 0.122, green: 0.396, blue: 0.671, alpha: 1)
        let bb_Orange = UIColor(red: 0.933, green: 0.506, blue: 0.184, alpha: 1)
        let bb_font = UIFont(name: "Optima-Bold", size: 18.0)
        
        navBar.barTintColor = bb_Blue
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: bb_Orange, NSFontAttributeName: bb_font!]
        
    }
    

    
    @IBOutlet weak var navBar: UINavigationBar!
    
}
