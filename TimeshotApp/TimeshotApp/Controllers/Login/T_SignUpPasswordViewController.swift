//
//  T_SignUpPasswordViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_SignUpPasswordViewController: UIViewController {
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var user : T_User?
    let passwordValidator = T_ValidatorHelper.passwordValidator()
    
    var nextButton  : UIBarButtonItem?
    var previousButton  : UIBarButtonItem?
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .Default
        toolbar.translucent = false
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "OK", style: .Done, target: self, action: #selector(keyboardDone))
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        
        self.nextButton  = UIBarButtonItem(title: ">", style: .Plain, target: self, action: #selector(keyboardNext))
        self.previousButton  = UIBarButtonItem(title: "<", style: .Plain, target: self, action: #selector(keyboardPrevious))
        
        toolbar.setItems([fixedSpaceButton, self.previousButton!, fixedSpaceButton, self.nextButton!, flexibleSpaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        T_DesignHelper.addSubBorder(passwordTextField)
        T_DesignHelper.addSubBorder(confirmPasswordTextField)
        
        T_DesignHelper.colorPlaceHolder(confirmPasswordTextField)
        T_DesignHelper.colorPlaceHolder(passwordTextField)
        
        T_DesignHelper.addRoundBorder(continueButton)
        T_DesignHelper.colorBorderButton(continueButton)
        T_DesignHelper.colorUIView(overlayView)
        
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === continueButton {
            if let signupUsernameView = segue.destinationViewController as? T_SignUpUsernameViewController {
                let password : String? = confirmPasswordTextField.text
                if let user = user {
                    user.password = password
                    signupUsernameView.user = user
                }
                
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if confirmPasswordTextField.text != passwordTextField.text {
            T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: [NSLocalizedString("Passwords are not matching", comment: "")], viewController: self)
            return false
        }
        else {
            passwordValidator.validate(confirmPasswordTextField.text, context: nil)
            if !passwordValidator.errors.isEmpty {
                let errors = T_ValidatorHelper.getAllErrors([passwordValidator])
                T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: errors, viewController: self)
                return false
            }
        }
        return true
    }
    @IBAction func tap(sender: AnyObject) {
        if passwordTextField.editing{
            passwordTextField.resignFirstResponder()
        }
        if confirmPasswordTextField.editing{
            confirmPasswordTextField.resignFirstResponder()
        }
    }
    func keyboardDone() -> Void {
        if passwordTextField.editing{
            passwordTextField.resignFirstResponder()
        }
        else{
            confirmPasswordTextField.resignFirstResponder()
        }
    }
    func keyboardNext() -> Void {
        if passwordTextField.editing{
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        }
        
    }
    func keyboardPrevious() -> Void {
        if confirmPasswordTextField.editing{
            passwordTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
    }
    

}

extension T_SignUpPasswordViewController: UITextFieldDelegate {
    // MARK: - Text Field Delegate
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.inputAccessoryView = inputToolbar
        if textField === passwordTextField{
            if let previous = self.previousButton, next = self.nextButton {
                next.enabled = true
                previous.enabled = false
            }
        }
        else {
            if let previous = self.previousButton, next = self.nextButton {
                next.enabled = false
                previous.enabled = true
            }
        }
        
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
}
