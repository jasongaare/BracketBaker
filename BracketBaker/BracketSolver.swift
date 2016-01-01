//
//  BracketSolver.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/1/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import Foundation

class BracketSolver {
    
    var placeholder = ""
    
    // ARRAY COLUMNS: [bracket region] / [regional seeding] / [team name] / [RPI ranking]
    
    var masterArray : [[String]] = []
    var midwestArray : [[String]] = []
    var westArray : [[String]] = []
    var southArray : [[String]] = []
    var eastArray : [[String]] = []
    
    var mwFinal = ""
    var wFinal = ""
    var eFinal = ""
    var sFinal = ""
    
    var final1 = ""
    var final2 = ""
    var winner = ""
    
    func fillOutBracket(prefs : UserSelectedPrefs) {
        
        var randomNumber : Int = 0
        
        // Fill in the final four
        
        // Midwest
        if(prefs.midwestFinal == placeholder) {
            randomNumber = Int(arc4random_uniform(16))
            self.mwFinal = self.midwestArray[randomNumber][2]
        }
        else {
            self.mwFinal = prefs.midwestFinal
        }
        
        // West
        if(prefs.westFinal == placeholder) {
            randomNumber = Int(arc4random_uniform(16))
            self.wFinal = self.westArray[randomNumber][2]
        }
        else {
            self.wFinal = prefs.westFinal
        }
        
        // South
        if(prefs.southFinal == placeholder) {
            randomNumber = Int(arc4random_uniform(16))
            self.sFinal = self.southArray[randomNumber][2]
        }
        else {
            self.sFinal = prefs.southFinal
        }
        
        // East
        if(prefs.eastFinal == placeholder) {
            randomNumber = Int(arc4random_uniform(16))
            self.eFinal = self.eastArray[randomNumber][2]
        }
        else {
            self.eFinal = prefs.eastFinal
        }
        
        
        // Pick from the midwest/west final four teams
        if(prefs.final1 == placeholder)
        {
            // If the user has no preference, pick randomly
            
            if(Int(arc4random_uniform(2)) == 1) {
                self.final1 = self.mwFinal
            }
            else {
                self.final1 = self.wFinal
            }
        }
        else {
            self.final1 = prefs.final1
        }
        
        // Pick from the south/east final four teams
        if(prefs.final2 == placeholder)
        {
            // If the user has no preference, pick randomly
            
            if(Int(arc4random_uniform(2)) == 1) {
                self.final2 = self.sFinal
            }
            else {
                self.final2 = self.eFinal
            }
        }
        else {
            self.final2 = prefs.final2
        }
        

        // Pick winner
        if(prefs.winner == placeholder)
        {
            // If the user has no preference, pick randomly
        
            if(Int(arc4random_uniform(2)) == 1) {
                self.winner = self.final1
            }
            else {
                self.winner = self.final2
            }
        }
        else {
            self.winner = prefs.winner
        }
        
        
        print("MW: \(self.mwFinal)")
        print("W: \(self.wFinal)")
        print("S: \(self.sFinal)")
        print("E: \(self.eFinal)")
        print("F1: \(self.final1)")
        print("F2: \(self.final2)")
        print("WIN: \(self.winner)")
        
        
    }
    
    init(masterArray: [[String]], mwArray: [[String]], wArray: [[String]], sArray: [[String]], eArray: [[String]], ph: String)
    {
        self.masterArray = masterArray
        self.midwestArray = mwArray
        self.westArray = wArray
        self.southArray = sArray
        self.eastArray = eArray
        self.placeholder = ph
    }
    
    
}