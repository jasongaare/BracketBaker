//
//  BracketToDisplay.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/12/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import Foundation

class BracketToDisplay : NSObject {
    
    var midwest : [[String]] = []
    var west : [[String]] = []
    var east : [[String]] = []
    var south : [[String]] = []
    var champs : [[String]] = []
    
    init(mw: [[String]], w: [[String]], e: [[String]], s: [[String]], c: [[String]]) {
        
        self.midwest = mw
        self.west = w
        self.east = e
        self.south = s
        self.champs = c
        
    }
    
}