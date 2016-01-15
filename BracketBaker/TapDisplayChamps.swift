//
//  TabDisplayChamps.swift
//  BracketBaker
//
//  Created by Jason Gaare on 1/15/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class TabDisplayChamps: UIView {
    
    var mwFinal : UILabel
    var wFinal : UILabel
    var eFinal : UILabel
    var sFinal : UILabel
    var final1 : UILabel
    var final2 : UILabel
    var champion : UILabel

    
    //This is how we draw everything
    override func drawRect(rect: CGRect)
    {
        let spacer : CGFloat = 1
        let spacerLR : CGFloat = 4
        
        // This makes some settings things
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.5)
        //        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        //        let color = CGColorCreate(colorSpace, components)
        //        CGContextSetStrokeColorWithColor(context, color)
        
        
        // Lines for Matchup #1
        let mwfLeft = CGPointMake(mwFinal.frame.origin.x, CGRectGetMaxY(mwFinal.frame) + spacer)
        let mwfRight = CGPointMake(CGRectGetMaxX(mwFinal.frame), CGRectGetMaxY(mwFinal.frame) + spacer)
        let wfRight = CGPointMake(CGRectGetMaxX(wFinal.frame), CGRectGetMaxY(wFinal.frame) + spacer)
        let wfLeft = CGPointMake(wFinal.frame.origin.x, CGRectGetMaxY(wFinal.frame) + spacer)
        
        CGContextMoveToPoint(context, mwfLeft.x, mwfLeft.y)
        CGContextAddLineToPoint(context, mwfRight.x, mwfRight.y)
        CGContextAddLineToPoint(context, wfRight.x, wfRight.y)
        CGContextAddLineToPoint(context, wfLeft.x, wfLeft.y)
        
        // Draw line under Final1 winner
        
        let f1Left = CGPointMake(CGRectGetMaxX(mwFinal.frame), CGRectGetMaxY(final1.frame) + spacer)
        let f1Right = CGPointMake(CGRectGetMaxX(final1.frame) - spacerLR,CGRectGetMaxY(final1.frame) + spacer)
        
        CGContextMoveToPoint(context, f1Left.x, f1Left.y)
        CGContextAddLineToPoint(context, f1Right.x, f1Right.y)
        
        // Lines for Matchup #2
        let efLeft = CGPointMake(eFinal.frame.origin.x, CGRectGetMaxY(eFinal.frame) + spacer)
        let efRight = CGPointMake(CGRectGetMaxX(eFinal.frame), CGRectGetMaxY(eFinal.frame) + spacer)
        let sfRight = CGPointMake(CGRectGetMaxX(sFinal.frame), CGRectGetMaxY(sFinal.frame) + spacer)
        let sfLeft = CGPointMake(sFinal.frame.origin.x, CGRectGetMaxY(sFinal.frame) + spacer)
        
        CGContextMoveToPoint(context, efRight.x, efRight.y)
        CGContextAddLineToPoint(context, efLeft.x, efLeft.y)
        CGContextAddLineToPoint(context, sfLeft.x, sfLeft.y)
        CGContextAddLineToPoint(context, sfRight.x, sfRight.y)
        
        // Draw line under winner
        
        let f2Left = CGPointMake(CGRectGetMinX(final2.frame) + spacerLR, CGRectGetMaxY(final2.frame) + spacer)
        let f2Right = CGPointMake(CGRectGetMinX(eFinal.frame),CGRectGetMaxY(final2.frame) + spacer)
        
        CGContextMoveToPoint(context, f2Right.x, f2Right.y)
        CGContextAddLineToPoint(context, f2Left.x, f2Left.y)
        
        
        
        // Draw those lines!
        CGContextStrokePath(context)
        
    }
    
    // Initializer
    required init?(coder aDecoder: NSCoder) {
        
        // Get these puppies cooking
        self.mwFinal = UILabel()
        self.wFinal = UILabel()
        self.eFinal = UILabel()
        self.sFinal = UILabel()
        self.final1 = UILabel()
        self.final2 = UILabel()
        self.champion = UILabel()
        
        // Let's go up and init too
        super.init(coder: aDecoder)
    }
    
}
