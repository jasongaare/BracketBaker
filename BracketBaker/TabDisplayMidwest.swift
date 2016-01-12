//
//  TabDisplayMidwest.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/12/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class TabDisplayMidwest: UIView {

    var team1 : UILabel
    var team2 : UILabel
    var team3 : UILabel
    var team4 : UILabel
    var team5 : UILabel
    var team6 : UILabel
    var team7 : UILabel
    var team8 : UILabel
    
    //This is how we draw everything
    override func drawRect(rect: CGRect)
    {
        let spacer : CGFloat = 5
        
        // This makes some settings things
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
  /*
        
        // Loop through pairings and draw lines for each matchup
        // There are 4 matchups for now
        var startTeam : Int
        var teamA : UILabel
        var teamB : UILabel
        var teamALeft : CGPoint
        var teamARight : CGPoint
        var teamBLeft : CGPoint
        var teamBRight : CGPoint
        
        for i in 0...3 {
            startTeam = i*2
            
            // Get team labels from array
            teamA = labelArray[startTeam]
            teamB = labelArray[startTeam+1]
            
            // Get points for lines
            teamALeft = CGPointMake(teamB.frame.origin.x, CGRectGetMaxY(teamA.frame) + spacer)
            teamARight = CGPointMake(CGRectGetMaxX(teamA.frame), CGRectGetMaxY(teamA.frame) + spacer)
            teamBRight = CGPointMake(CGRectGetMaxX(teamB.frame), CGRectGetMaxY(teamB.frame) + spacer)
            teamBLeft = CGPointMake(teamB.frame.origin.x, CGRectGetMaxY(teamB.frame) + spacer)
            
            // Guide the lines
            CGContextMoveToPoint(context, teamALeft.x, teamALeft.y)
            CGContextAddLineToPoint(context, teamARight.x, teamARight.y)
            CGContextAddLineToPoint(context, teamBRight.x, teamBRight.y)
            CGContextAddLineToPoint(context, teamBLeft.x, teamBLeft.y)
            
            print("Loop \(i)")
        }
    */
        
        // Lines for Matchup #1
        let team1Left = CGPointMake(team1.frame.origin.x, CGRectGetMaxY(team1.frame) + spacer)
        let team1Right = CGPointMake(CGRectGetMaxX(team1.frame), CGRectGetMaxY(team1.frame) + spacer)
        let team2Right = CGPointMake(CGRectGetMaxX(team2.frame), CGRectGetMaxY(team2.frame) + spacer)
        let team2Left = CGPointMake(team2.frame.origin.x, CGRectGetMaxY(team2.frame) + spacer)
        
        CGContextMoveToPoint(context, team1Left.x, team1Left.y)
        CGContextAddLineToPoint(context, team1Right.x, team1Right.y)
        CGContextAddLineToPoint(context, team2Right.x, team2Right.y)
        CGContextAddLineToPoint(context, team2Left.x, team2Left.y)
        
        // Lines for Matchup #2
        
        let team3Left = CGPointMake(team3.frame.origin.x, CGRectGetMaxY(team3.frame) + spacer)
        let team3Right = CGPointMake(CGRectGetMaxX(team3.frame), CGRectGetMaxY(team3.frame) + spacer)
        let team4Right = CGPointMake(CGRectGetMaxX(team4.frame), CGRectGetMaxY(team4.frame) + spacer)
        let team4Left = CGPointMake(team4.frame.origin.x, CGRectGetMaxY(team4.frame) + spacer)

        CGContextMoveToPoint(context, team3Left.x, team3Left.y)
        CGContextAddLineToPoint(context, team3Right.x, team3Right.y)
        CGContextAddLineToPoint(context, team4Right.x, team4Right.y)
        CGContextAddLineToPoint(context, team4Left.x, team4Left.y)
        
        // Lines for Matchup #3
        
        let team5Left = CGPointMake(team5.frame.origin.x, CGRectGetMaxY(team5.frame) + spacer)
        let team5Right = CGPointMake(CGRectGetMaxX(team5.frame), CGRectGetMaxY(team5.frame) + spacer)
        let team6Right = CGPointMake(CGRectGetMaxX(team6.frame), CGRectGetMaxY(team6.frame) + spacer)
        let team6Left = CGPointMake(team6.frame.origin.x, CGRectGetMaxY(team6.frame) + spacer)
        
        CGContextMoveToPoint(context, team5Left.x, team5Left.y)
        CGContextAddLineToPoint(context, team5Right.x, team5Right.y)
        CGContextAddLineToPoint(context, team6Right.x, team6Right.y)
        CGContextAddLineToPoint(context, team6Left.x, team6Left.y)

        // Lines for Matchup #4
        
        let team7Left = CGPointMake(team7.frame.origin.x, CGRectGetMaxY(team7.frame) + spacer)
        let team7Right = CGPointMake(CGRectGetMaxX(team7.frame), CGRectGetMaxY(team7.frame) + spacer)
        let team8Right = CGPointMake(CGRectGetMaxX(team8.frame), CGRectGetMaxY(team8.frame) + spacer)
        let team8Left = CGPointMake(team8.frame.origin.x, CGRectGetMaxY(team8.frame) + spacer)
        
        CGContextMoveToPoint(context, team7Left.x, team7Left.y)
        CGContextAddLineToPoint(context, team7Right.x, team7Right.y)
        CGContextAddLineToPoint(context, team8Right.x, team8Right.y)
        CGContextAddLineToPoint(context, team8Left.x, team8Left.y)
        
        // Draw those lines!
        CGContextStrokePath(context)
        
    }
    
    // Initializer
    required init?(coder aDecoder: NSCoder) {
        
        // Get these puppies cooking
        self.team1 = UILabel()
        self.team2 = UILabel()
        self.team3 = UILabel()
        self.team4 = UILabel()
        self.team5 = UILabel()
        self.team6 = UILabel()
        self.team7 = UILabel()
        self.team8 = UILabel()
        
        // Let's go up and init too
        super.init(coder: aDecoder)
    }
}
