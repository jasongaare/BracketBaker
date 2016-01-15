//
//  TabDisplayRegion.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/13/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class TabDisplayRegion: UIView {
   
    var team1 : UILabel
    var team2 : UILabel
    var team3 : UILabel
    var team4 : UILabel
    var team5 : UILabel
    var team6 : UILabel
    var team7 : UILabel
    var team8 : UILabel
    var team9 : UILabel
    var team10 : UILabel
    var team11 : UILabel
    var team12 : UILabel
    var team13 : UILabel
    var team14 : UILabel
    var team15 : UILabel
    
    //This is how we draw everything
    override func drawRect(rect: CGRect)
    {
        let spacer : CGFloat = 1
        
        // This makes some settings things
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.5)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
//        let color = CGColorCreate(colorSpace, components)
//        CGContextSetStrokeColorWithColor(context, color)
        
        
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
        
        // Lines for Matchup #5
        
        // Now we want the "left" to be equal to the right of the previous column of teams
        let team9Left = CGPointMake(CGRectGetMaxX(team1.frame), CGRectGetMaxY(team9.frame) + spacer)
        let team9Right = CGPointMake(CGRectGetMaxX(team9.frame), CGRectGetMaxY(team9.frame) + spacer)
        let team10Right = CGPointMake(CGRectGetMaxX(team10.frame), CGRectGetMaxY(team10.frame) + spacer)
        let team10Left = CGPointMake(CGRectGetMaxX(team2.frame), CGRectGetMaxY(team10.frame) + spacer)
        
        CGContextMoveToPoint(context, team9Left.x, team9Left.y)
        CGContextAddLineToPoint(context, team9Right.x, team9Right.y)
        CGContextAddLineToPoint(context, team10Right.x, team10Right.y)
        CGContextAddLineToPoint(context, team10Left.x, team10Left.y)
        
        // Lines for Matchup #6
        
        // Now we want the "left" to be equal to the right of the previous column of teams
        let team11Left = CGPointMake(CGRectGetMaxX(team5.frame), CGRectGetMaxY(team11.frame) + spacer)
        let team11Right = CGPointMake(CGRectGetMaxX(team11.frame), CGRectGetMaxY(team11.frame) + spacer)
        let team12Right = CGPointMake(CGRectGetMaxX(team12.frame), CGRectGetMaxY(team12.frame) + spacer)
        let team12Left = CGPointMake(CGRectGetMaxX(team7.frame), CGRectGetMaxY(team12.frame) + spacer)
        
        CGContextMoveToPoint(context, team11Left.x, team11Left.y)
        CGContextAddLineToPoint(context, team11Right.x, team11Right.y)
        CGContextAddLineToPoint(context, team12Right.x, team12Right.y)
        CGContextAddLineToPoint(context, team12Left.x, team12Left.y)
        
        // Lines for Matchup #7
        
        // Now we want the "left" to be equal to the right of the previous column of teams
        let team13Left = CGPointMake(CGRectGetMaxX(team10.frame), CGRectGetMaxY(team13.frame) + spacer)
        let team13Right = CGPointMake(CGRectGetMaxX(team13.frame), CGRectGetMaxY(team13.frame) + spacer)
        let team14Right = CGPointMake(CGRectGetMaxX(team14.frame), CGRectGetMaxY(team14.frame) + spacer)
        let team14Left = CGPointMake(CGRectGetMaxX(team12.frame), CGRectGetMaxY(team14.frame) + spacer)
        
        CGContextMoveToPoint(context, team13Left.x, team13Left.y)
        CGContextAddLineToPoint(context, team13Right.x, team13Right.y)
        CGContextAddLineToPoint(context, team14Right.x, team14Right.y)
        CGContextAddLineToPoint(context, team14Left.x, team14Left.y)
        
        // Draw line under winner
        
        let team15Left = CGPointMake(CGRectGetMaxX(team13.frame), CGRectGetMaxY(team15.frame) + spacer)
        let team15Right = CGPointMake(CGRectGetMaxX(team15.frame),CGRectGetMaxY(team15.frame) + spacer)
        
        CGContextMoveToPoint(context, team15Left.x, team15Left.y)
        CGContextAddLineToPoint(context, team15Right.x, team15Right.y)
        
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
        self.team9 = UILabel()
        self.team10 = UILabel()
        self.team11 = UILabel()
        self.team12 = UILabel()
        self.team13 = UILabel()
        self.team14 = UILabel()
        self.team15 = UILabel()
        
        // Let's go up and init too
        super.init(coder: aDecoder)
    }

}
