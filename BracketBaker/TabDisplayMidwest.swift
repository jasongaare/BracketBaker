//
//  TabDisplayMidwest.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/11/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class TabDisplayMidwest: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do stuff here
        print("Hello from midwest")

        let tdvc = self.tabBarController as! TabDisplayViewController
        let midwestArray = tdvc.bracketData.midwest
        
        print("Winner of the Midwest is: \(midwestArray[14][2])")

    }
}
