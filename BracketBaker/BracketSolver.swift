//
//  BracketSolver.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/1/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import Foundation

class BracketSolver {
    
    var final1 = ""
    var final2 = ""
    var winner = ""
    
    func fillOutBracket(prefs : UserSelectedPrefs) {
        
        // Randomly pick from the two final four teams
        if(Int(arc4random_uniform(2)) == 1) {
            self.final1 = prefs.midwestFinal
        }
        else {
            self.final1 = prefs.westFinal
        }
        
        // Randomly pick from the two final four teams
        if(Int(arc4random_uniform(2)) == 1) {
            self.final2 = prefs.southFinal
        }
        else {
            self.final2 = prefs.eastFinal
        }
        
        // Randomly pick winner
        if(Int(arc4random_uniform(2)) == 1) {
            self.winner = self.final1
        }
        else {
            self.winner = self.final2
        }
        
    }
    
}