//
//  T_SignUpUsernameViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_SignUpUsernameViaFacebookViewController: T_SignUpUsernameViewController {
    /*@IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var user : T_User?
    var usernameValidator = T_ValidatorHelper.userNameValidator()*/
    
    /*override func viewDidLoad() {
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
        
    }*/
    
    // MARK: - Navigation
    
    @IBAction func userNameValidation(sender: AnyObject) {
        
        usernameValidator.validate(usernameTextField.text, context: nil)
        if usernameValidator.errors.isEmpty{
            //TODO Verifier Username pas déjà pris
            user?.username = usernameTextField.text
            user?.saveInBackgroundWithBlock{ sucess, error -> Void in
                if sucess {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                else {
                    //TODO Couldn't save username
                }
            }
        }
        else {
            //TODO Alert, username not compliante
        }
        
    }
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === continueButton {
            if let signupInviteView = segue.destinationViewController as? T_SignUpInvitePeopleViewController {
                let username : String? = usernameTextField.text
                if let user = user {
                    user.username = username
                    signupInviteView.user = user
                }
            }
            
        }
    }*/
    
    
}

/*extension T_SignUpUsernameViaFacebookViewController: UITextFieldDelegate {
    // MARK: - Text Field Delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
}*/