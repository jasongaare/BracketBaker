//
//  BracketSolver.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/1/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import Foundation

class BracketSolver {
    
    // MARK: Variables
    
    var placeholder = ""
    
    // ARRAY COLUMNS: [bracket region] / [regional seeding] / [team name] / [RPI ranking]
    
    var masterArray : [[String]] = []
    var midwestArray : [[String]] = []
    var westArray : [[String]] = []
    var southArray : [[String]] = []
    var eastArray : [[String]] = []
    
    var mwFinal : [String] = []
    var wFinal : [String] = []
    var eFinal : [String] = []
    var sFinal : [String] = []
    
    var final1 : [String] = []
    var final2 : [String] = []
    var winner : [String] = []
    
    var completeBracket : BracketToDisplay = BracketToDisplay(mw: [], w: [], e: [], s: [], c: [])
    
    // MARK: Solver Functions
    
    func fillOutBracket(prefs : UserSelectedPrefs) {
        
        // Populate each region of the bracket
        
        var midwestComplete = populateRegion(midwestArray, userWinner: prefs.midwestFinal)
        var westComplete = populateRegion(westArray, userWinner: prefs.westFinal)
        var eastComplete = populateRegion(eastArray, userWinner: prefs.eastFinal)
        var southComplete = populateRegion(southArray, userWinner: prefs.southFinal)
        
        // Populate in the final four from the solved regions
        
        self.mwFinal = midwestComplete[14]
        self.wFinal = westComplete[14]
        self.eFinal = eastComplete[14]
        self.sFinal = southComplete[14]
        
        
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
            if prefs.final1 == self.mwFinal[2] {
                self.final1 = self.mwFinal
            }
            else {
                self.final1 = self.wFinal
            }
            
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
            if prefs.final2 == self.eFinal[2] {
                self.final2 = self.eFinal
            }
            else {
                self.final2 = self.sFinal
            }
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
            switch prefs.winner {
            case mwFinal[2]:
                self.winner = self.mwFinal
            case wFinal[2]:
                self.winner = self.wFinal
            case eFinal[2]:
                self.winner = self.eFinal
            case sFinal[2]:
                self.winner = self.sFinal
            default: break
            }
        }
        
        
        
        //--Compile bracket into a BracketToDisplay--//
        
        // Create champs array
        var champs : [[String]] = []
        champs.append(self.mwFinal)
        champs.append(self.wFinal)
        champs.append(self.eFinal)
        champs.append(self.sFinal)
        champs.append(self.final1)
        champs.append(self.final2)
        champs.append(self.winner)
        
        
        // Create complete bracket, ready to segue
        self.completeBracket = BracketToDisplay(mw: midwestComplete, w: westComplete, e: eastComplete, s: southComplete, c: champs)
        
    }
    
    func populateRegion(initArray: [[String]], userWinner: String) -> [[String]]
    {
        /*
        REGIONAL WINNER DATA ARRANGEMENT
        
        Second Round Winners    -- [0-7]
        Third Round Winners     -- [8-11]
        Regional Semi Winners   -- [12-13]
        Regional Winner         -- [14]
        */
        
        var winnerArray : [[String]] = []
        var firstTeamPos = 0
        var teamSeedA = 0
        var teamSeedB = 0
        var seedSum = 0
        var randomNum = 0
        
        /* SECOND ROUND */
        // There are eight second round matchups in each region
        for counter in 0...7 {
            
            firstTeamPos = counter * 2
         
            // Check if the user selected this team to win
            if(initArray[firstTeamPos][2] == userWinner) {
                winnerArray.append(initArray[firstTeamPos])
            }
            else if(initArray[firstTeamPos+1][2] == userWinner) {
                winnerArray.append(initArray[firstTeamPos+1])
            }
                
            // If not a user-selected winner, we must determine randomly
            else {
                //Determine winner of each game
                teamSeedA = Int(initArray[firstTeamPos][1])!
                teamSeedB = Int(initArray[firstTeamPos+1][1])!
                seedSum = teamSeedA + teamSeedB
            
                /* 
                /  Odds of Team A winning are equal to (teamSeedB / seedsum)
                /  Odds of Team B winning are equal to (teamSeedA / seedsum)
                */
            
                randomNum = Int(arc4random_uniform(UInt32(seedSum)))
            
                // If the random number is great than seed A, it is in the seedB portion, therefore teamA wins
                if(randomNum > teamSeedA) {
                    winnerArray.append(initArray[firstTeamPos])
                }
                else {
                    winnerArray.append(initArray[firstTeamPos+1])
                }
            }
            
        }
        
        /* THIRD ROUND */
        // There are four third round matchups
        for counter in 0...3 {
            
            firstTeamPos = counter * 2
            
            // Check if the user selected this team to win
            if(winnerArray[firstTeamPos][2] == userWinner) {
                winnerArray.append(winnerArray[firstTeamPos])
            }
            else if(winnerArray[firstTeamPos+1][2] == userWinner) {
                winnerArray.append(winnerArray[firstTeamPos+1])
            }
                
            // If not a user-selected winner, we must determine randomly
            else {
                //Determine winner of each game
                teamSeedA = Int(winnerArray[firstTeamPos][1])!
                teamSeedB = Int(winnerArray[firstTeamPos+1][1])!
                seedSum = teamSeedA + teamSeedB
                
                //Odds of Team A winning are equal to (teamSeedB / seedsum)
                //Odds of Team B winning are equal to (teamSeedA / seedsum)
                
                randomNum = Int(arc4random_uniform(UInt32(seedSum)))
                
                if(randomNum > teamSeedA) {
                    winnerArray.append(winnerArray[firstTeamPos])
                }
                else {
                    winnerArray.append(winnerArray[firstTeamPos+1])
                }
            }
        }
        
        /* REGIONAL SEMI-FINAL */
        // There are two semi games (teams starting in [8] in our array
        for counter in 4...5 {
            
            firstTeamPos = counter * 2
            
            // Check if the user selected this team to win
            if(winnerArray[firstTeamPos][2] == userWinner) {
                winnerArray.append(winnerArray[firstTeamPos])
            }
            else if(winnerArray[firstTeamPos+1][2] == userWinner) {
                winnerArray.append(winnerArray[firstTeamPos+1])
            }
                
                // If not a user-selected winner, we must determine randomly
            else {
                //Determine winner of each game
                teamSeedA = Int(winnerArray[firstTeamPos][1])!
                teamSeedB = Int(winnerArray[firstTeamPos+1][1])!
                seedSum = teamSeedA + teamSeedB
                
                //Odds of Team A winning are equal to (teamSeedB / seedsum)
                //Odds of Team B winning are equal to (teamSeedA / seedsum)
                
                randomNum = Int(arc4random_uniform(UInt32(seedSum)))
                
                if(randomNum > teamSeedA) {
                    winnerArray.append(winnerArray[firstTeamPos])
                }
                else {
                    winnerArray.append(winnerArray[firstTeamPos+1])
                }
            }
        }
        
        /* REGIONAL FINAL */
            
            firstTeamPos = 12
            
            // Check if the user selected this team to win
            if(winnerArray[firstTeamPos][2] == userWinner) {
                winnerArray.append(winnerArray[firstTeamPos])
            }
            else if(winnerArray[firstTeamPos+1][2] == userWinner) {
                winnerArray.append(winnerArray[firstTeamPos+1])
            }
            
            // If not a user-selected winner, we must determine randomly
            else {
                //Determine winner of each game
                teamSeedA = Int(winnerArray[firstTeamPos][1])!
                teamSeedB = Int(winnerArray[firstTeamPos+1][1])!
                seedSum = teamSeedA + teamSeedB
            
                //Odds of Team A winning are equal to (teamSeedB / seedsum)
                //Odds of Team B winning are equal to (teamSeedA / seedsum)
            
                randomNum = Int(arc4random_uniform(UInt32(seedSum)))
            
                if(randomNum > teamSeedA) {
                    winnerArray.append(winnerArray[firstTeamPos])
                }
                else {
                    winnerArray.append(winnerArray[firstTeamPos+1])
                }
        }
        
        
        return winnerArray
    }
    
    
    // MARK: Initializers
    
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