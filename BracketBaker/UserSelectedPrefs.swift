//
//  UserSelectedPrefs.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/1/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import Foundation

class UserSelectedPrefs : NSObject {
    
    var midwestFinal = ""
    var westFinal = ""
    var southFinal = ""
    var eastFinal = ""
    
    var final1 = ""
    var final2 = ""
    var winner = ""
    
    var upsets : Float = 0
    var cinderella = ""
    
    init(mwFinal: String, wFinal: String, sFinal: String, eFinal: String, final1: String, final2: String, winner: String, upsets: Float, cinderella: String) {
        
        self.midwestFinal = mwFinal
        self.westFinal = wFinal
        self.southFinal = sFinal
        self.eastFinal = eFinal
        
        self.final1 = final1
        self.final2 = final2
        self.winner = winner
        
        self.upsets = upsets
        self.cinderella = cinderella
        
    }
    
}
