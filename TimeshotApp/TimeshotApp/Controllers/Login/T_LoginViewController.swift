//
//  T_LoginViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import SwiftValidate
import Parse
import MBProgressHUD

class T_LoginViewController: UIViewController {
    
    
    // MARK : Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var overlayView: UIView!
    let usernameValidator : ValidatorChain
    let passwordValidator : ValidatorChain
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
    
    var progressHUD:MBProgressHUD?
    
    required init?(coder aDecoder: NSCoder) {
        usernameValidator = T_ValidatorHelper.firstNameValidator()
        passwordValidator = T_ValidatorHelper.passwordValidator()
        
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navbar = self.navigationController?.navigationBar {
            T_DesignHelper.colorNavBar(navbar)
        }
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        T_DesignHelper.addSubBorder(usernameTextField)
        T_DesignHelper.addSubBorder(passwordTextField)
        
        T_DesignHelper.colorPlaceHolder(usernameTextField)
        T_DesignHelper.colorPlaceHolder(passwordTextField)
        
        T_DesignHelper.addRoundBorder(signInButton)
        T_DesignHelper.colorBorderButton(signInButton)
        
        T_DesignHelper.colorUIView(overlayView)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    func freezeUI() {
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD?.mode = .Indeterminate
    }
    
    func unfreezeUI() {
        progressHUD?.hide(true)
    }
    
    // MARK : Actions
    
    @IBAction func signInTapped(sender: AnyObject) {
        usernameValidator.validate(usernameTextField.text, context: nil)
        passwordValidator.validate(passwordTextField.text, context: nil)
        let errors : [String] = T_ValidatorHelper.getAllErrors([usernameValidator, passwordValidator])
        if !errors.isEmpty {
            T_AlertHelper.alert(NSLocalizedString("Cannot sign in", comment: ""), errors: errors, viewController: self)
        }
        else {
            self.freezeUI()
            PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!) { (user : PFUser?, error : NSError? ) -> Void in
                self.unfreezeUI()
                if let _ = user {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                } else {
                    T_AlertHelper.alert(NSLocalizedString("Cannot sign in", comment: ""), errors: [NSLocalizedString("Username and/or password incorect", comment: "")], viewController: self)
                }
            }
       
        }
    }
    
    @IBAction func tap(sender: AnyObject) {
        if usernameTextField.editing{
            usernameTextField.resignFirstResponder()
        }
        if passwordTextField.editing{
            passwordTextField.resignFirstResponder()
        }
    }
    
    func keyboardDone() -> Void {
        if usernameTextField.editing{
            usernameTextField.resignFirstResponder()
        }
        else{
            passwordTextField.resignFirstResponder()
        }
    }
    func keyboardNext() -> Void {
        if usernameTextField.editing{
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }

    }
    func keyboardPrevious() -> Void {
        if passwordTextField.editing{
            passwordTextField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
        }
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension T_LoginViewController : UITextFieldDelegate {
    
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.inputAccessoryView = inputToolbar
        if textField === usernameTextField{
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


