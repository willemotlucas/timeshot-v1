//
//  T_SignUpPasswordViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import CameraManager

class T_SignUpPasswordViewController: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    let cameraManager = CameraManager()
    var user : T_User?
    let passwordValidator = T_ValidatorHelper.passwordValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraManager.cameraDevice = .Front
        self.cameraManager.addPreviewLayerToView(self.cameraView)
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
}

extension T_SignUpPasswordViewController: UITextFieldDelegate {
    // MARK: - Text Field Delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
}
