//
//  T_SnapTextField.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 04/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_SnapTextField: UITextField, UITextFieldDelegate {
    
    var touched:Bool = false
    var lastPosition:CGPoint = CGPointZero
    var contentWidth:CGFloat = 1.0
    var shouldHide:Bool = true
    
    private
    unowned var target: UIView
    var parentFrameSize: CGRect!
    
    init(frame: CGRect, target: UIView, parentFrameSize: CGRect) {
        self.target = target
        
        super.init(frame: frame)
        
        self.parentFrameSize = parentFrameSize
        self.placeholder = ""
        self.font = UIFont.systemFontOfSize(16)
        self.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        self.borderStyle = UITextBorderStyle.None
        self.autocorrectionType = UITextAutocorrectionType.No
        self.keyboardType = UIKeyboardType.Default
        self.returnKeyType = UIReturnKeyType.Done
        self.clearButtonMode = UITextFieldViewMode.Never;
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.delegate = self
        self.target.addSubview(self)
        self.layer.zPosition = 15
        self.textAlignment = .Center
        self.contentHorizontalAlignment = .Center
        self.lastPosition.y = self.frame.origin.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Show the TextField when the user tap the screen
    func showTextInput(touchLocation: CGPoint) {
        
        if(touchLocation.y < 0)
        {
            self.lastPosition.y = 0
            self.frame.origin.y = 0
        }
        else if(touchLocation.y <= (self.parentFrameSize.height - 40))
        {
            self.lastPosition = touchLocation
            self.frame.origin.y = self.lastPosition.y
        }
        else
        {
            self.lastPosition.y = (self.parentFrameSize.height - 40)
            self.frame.origin.y = (self.parentFrameSize.height - 40)
        }
        
        self.frame.origin.y = 30
        
        self.hidden = false
        self.becomeFirstResponder()
    }

    func hideKeyboard() {
        self.resignFirstResponder();
    }
    
    func containsTouch(touchLocation: CGPoint) -> Bool {
        return CGRectContainsPoint(self.frame, touchLocation)
    }
    
    func setLocation(touchLocation: CGPoint) {
        // Condition to set properly the textfield (not too low, not to hight, not to be hidden)
        if(touchLocation.y < 0)
        {
            self.lastPosition.y = 0
            self.frame.origin.y = 0
        }
        else if (touchLocation.y <= (self.parentFrameSize.height - 40))
        {
            self.lastPosition = touchLocation
            self.frame.origin.y = self.lastPosition.y
        }
        else
        {
            self.lastPosition.y = self.parentFrameSize.height - 40
            self.frame.origin.y = self.parentFrameSize.height - 40
        }
    }
    
    func setPlaceHolder(text: String) {
        self.attributedPlaceholder = NSAttributedString(string:text, attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK:- Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    // If the TextField is empty, it's hidden
    func textFieldDidEndEditing(textField: UITextField) {
        if (self.text == "" && self.shouldHide)
        {
            self.hidden = true
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    // Limit the text size to the screen width
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text:NSString = (self.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        self.contentWidth = text.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16.0)]).width
        
        return self.contentWidth <= (self.parentFrameSize.width - 20)
    }
    
    // Hide the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: - Keyboard behaviour
    func keyboardWillShow(notification: NSNotification) {
        updatePosition(notification)
    }
    
    func keyboardTypeChanged(notification: NSNotification) {
        updatePosition(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.frame.origin.y = self.lastPosition.y
    }
    
    func updatePosition(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.frame.origin.y = self.parentFrameSize.size.height - keyboardSize.height - self.frame.size.height
        }
    }
}