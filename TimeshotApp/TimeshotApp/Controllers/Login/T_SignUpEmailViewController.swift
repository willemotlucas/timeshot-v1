//
//  T_SignUpEmailViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import SwiftValidate
import MBProgressHUD

class T_SignUpEmailViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    
    var progressHUD:MBProgressHUD?
    
    var firstNameValidator = T_ValidatorHelper.firstNameValidator()
    private var nameValidator = T_ValidatorHelper.nameValidator()
    private var emailValidator = T_ValidatorHelper.emailValidator()
    
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
        // Do any additional setup after loading the view.
        firstNameTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        T_DesignHelper.addSubBorder(nameTextField)
        T_DesignHelper.addSubBorder(firstNameTextField)
        T_DesignHelper.addSubBorder(emailTextField)
        
        T_DesignHelper.colorPlaceHolder(emailTextField)
        T_DesignHelper.colorPlaceHolder(nameTextField)
        T_DesignHelper.colorPlaceHolder(firstNameTextField)
        
        T_DesignHelper.addRoundBorder(continueButton)
        T_DesignHelper.colorBorderButton(continueButton)
        T_DesignHelper.colorUIView(overlayView)
        
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
            if let signupPasswordView = segue.destinationViewController as? T_SignUpPasswordViewController {
                let user = T_User()
                user.email = emailTextField.text
                user.firstName = firstNameTextField.text
                user.lastName = nameTextField.text
                signupPasswordView.user = user
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        firstNameValidator.validate(firstNameTextField.text, context: nil)
        nameValidator.validate(nameTextField.text, context: nil)
        emailValidator.validate(emailTextField.text, context: nil)
        
        let errors : [String] = T_ValidatorHelper.getAllErrors([firstNameValidator, nameValidator, emailValidator])
        if !errors.isEmpty {
            T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: errors, viewController: self)
            return false
        }
        freezeUI()
        T_ParseUserHelper.emailAlreadyExist(emailTextField.text!){ o -> Void in
            self.unfreezeUI()
            if o.1 == nil {
                if o.0?.count > 0 {
                    T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: [NSLocalizedString("This email is already used", comment: "")], viewController: self)
                }
                else {
                    self.performSegueWithIdentifier("toPasswordView", sender: sender)
                }
            }
            else {
                T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: [NSLocalizedString("Error while testing your email", comment: "")], viewController: self)
            }
        }
        return false
    }
    
    func keyboardDone() -> Void {
        if firstNameTextField.editing{
            firstNameTextField.resignFirstResponder()
        }
        else if nameTextField.editing {
            nameTextField.resignFirstResponder()
        }
        else if emailTextField.editing {
            emailTextField.resignFirstResponder()
        }
    }
    func keyboardNext() -> Void {
        if firstNameTextField.editing{
            firstNameTextField.resignFirstResponder()
            nameTextField.becomeFirstResponder()
        }
        else if nameTextField.editing {
            nameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        }
    }
    func keyboardPrevious() -> Void {
        if emailTextField.editing{
            emailTextField.resignFirstResponder()
            nameTextField.becomeFirstResponder()
        }
        else if nameTextField.editing {
            nameTextField.resignFirstResponder()
            firstNameTextField.becomeFirstResponder()
        }
    }
    
    
    
    
}

extension T_SignUpEmailViewController: UITextFieldDelegate {
    // MARK: - Text Field Delegate
    
    @IBAction func tapTap(sender: AnyObject) {
        if firstNameTextField.editing{
            firstNameTextField.resignFirstResponder()
        }
        if nameTextField.editing{
            nameTextField.resignFirstResponder()
        }
        if emailTextField.editing {
            emailTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.inputAccessoryView = inputToolbar
        if textField === firstNameTextField{
            if let previous = self.previousButton, next = self.nextButton {
                next.enabled = true
                previous.enabled = false
            }
        }
        else if textField === nameTextField {
            if let previous = self.previousButton, next = self.nextButton {
                next.enabled = true
                previous.enabled = true
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
}
