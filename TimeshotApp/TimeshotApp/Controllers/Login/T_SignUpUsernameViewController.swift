//
//  T_SignUpUsernameViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import MBProgressHUD

class T_SignUpUsernameViewController: UIViewController {
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var user : T_User?
    let usernameValidator = T_ValidatorHelper.userNameValidator()
    
    var progressHUD:MBProgressHUD?
    
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .Default
        toolbar.translucent = false
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "OK", style: .Done, target: self, action: #selector(keyboardDone))
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        T_DesignHelper.addSubBorder(usernameTextField)
        
        T_DesignHelper.colorPlaceHolder(usernameTextField)
        
        T_DesignHelper.addRoundBorder(continueButton)
        T_DesignHelper.colorBorderButton(continueButton)
        
        T_DesignHelper.colorUIView(overlayView)
        
    }
    
    @IBAction func tap(sender: AnyObject) {
        if usernameTextField.editing{
            usernameTextField.resignFirstResponder()
        }
    }
    // MARK: Methods
    func freezeUI() {
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD?.mode = .Indeterminate
    }
    
    func unfreezeUI() {
        progressHUD?.hide(true)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === continueButton {
            if let signupInviteView = segue.destinationViewController as? T_SignUpInvitePeopleViewController {
                let username : String? = usernameTextField.text
                if let user = user {
                    user.username = username
                    signupInviteView.user = user
                }
            }
            
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        usernameValidator.validate(usernameTextField.text, context: nil)
        if !usernameValidator.errors.isEmpty {
            let errors = T_ValidatorHelper.getAllErrors([usernameValidator])
            T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: errors, viewController: self)
            return false
        }
        freezeUI()
        let usernameAlreadyExist = T_ParseUserHelper.usernameAlreadyExist(usernameTextField.text!)
        unfreezeUI()
        if usernameAlreadyExist {
            T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: [NSLocalizedString("This username is already used", comment: "")], viewController: self)
            return false
        }
        return true
    }
    func keyboardDone() -> Void {
        usernameTextField.resignFirstResponder()
    }
    
}

extension T_SignUpUsernameViewController: UITextFieldDelegate {
    // MARK: - Text Field Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.inputAccessoryView = inputToolbar
        
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