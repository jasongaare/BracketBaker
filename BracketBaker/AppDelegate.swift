//
//  AppDelegate.swift
//  BracketBaker
//
//  Created by Jason Gaare on 12/7/15.
//  Copyright © 2015 Jason Gaare. All rights reserved.
//

import UIKit
import Fabric
import Answers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
                
        // This is for tracking things
        Fabric.with([Answers.self])
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
            // Do nothing
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        // Hide any pickers that may be up
        self.window?.endEditing(true)
        
        // Let's put up the splash screen whenever we enter background
        let launchStoryboard : UIStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchViewController : UIViewController = launchStoryboard.instantiateViewControllerWithIdentifier("LS") as UIViewController
        let launchView : UIView = launchViewController.view!
        self.window?.addSubview(launchView)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Do nothing
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        // If we added the launchview on top, let's remove it
        if(self.window?.subviews.count > 1) {
            self.window?.subviews.last?.removeFromSuperview()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Do nothing
    }


    
}

