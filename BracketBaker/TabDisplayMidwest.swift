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
    
    //This is how we draw everything
    override func drawRect(rect: CGRect)
    {
        let spacer : CGFloat = 5
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        
        let team1Left = CGPointMake(team1.frame.origin.x, CGRectGetMaxY(team1.frame) + spacer)
        let team1Right = CGPointMake(CGRectGetMaxX(team1.frame), CGRectGetMaxY(team1.frame) + spacer)
        let team2Right = CGPointMake(CGRectGetMaxX(team2.frame), CGRectGetMaxY(team2.frame) + spacer)
        let team2Left = CGPointMake(team2.frame.origin.x, CGRectGetMaxY(team2.frame) + spacer)
        
        CGContextMoveToPoint(context, team1Left.x, team1Left.y)
        CGContextAddLineToPoint(context, team1Right.x, team1Right.y)
        CGContextAddLineToPoint(context, team2Right.x, team2Right.y)
        CGContextAddLineToPoint(context, team2Left.x, team2Left.y)
        CGContextStrokePath(context)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.team1 = UILabel()
        self.team2 = UILabel()
        
        super.init(coder: aDecoder)
    }
}
