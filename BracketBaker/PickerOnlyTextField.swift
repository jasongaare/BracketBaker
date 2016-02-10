//
//  pickerOnlyTextField.swift
//  BracketBaker
//
//  Created by Jason Gaare on 2/10/16.
//  Copyright © 2016 Jason Gaare. All rights reserved.
//

import UIKit

class PickerOnlyTextField: UITextField {

   
    /*
     *    Code for this found at: http://blog.apoorvmote.com/remove-cursor-and-disable-copypaste-for-uitextfield/
     */
    
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    override func selectionRectsForRange(range: UITextRange) -> [AnyObject] {
        return []
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        if action == Selector("copy:") || action == Selector("selectAll:") || action == Selector("paste:") {
            
            return false
            
        }
        
        return super.canPerformAction(action, withSender: sender)
        
    }
    
}
