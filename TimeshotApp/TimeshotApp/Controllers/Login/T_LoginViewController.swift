//
//  T_LoginViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import CameraManager
import SwiftValidate
import ParseFacebookUtilsV4

class T_LoginViewController: UIViewController {
    
    
    // MARK : Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var overlayView: UIView!
    let cameraManager = CameraManager()
    let usernameValidator : ValidatorChain
    let passwordValidator : ValidatorChain
    
    required init?(coder aDecoder: NSCoder) {
        usernameValidator = T_ValidatorHelper.firstNameValidator()
        passwordValidator = T_ValidatorHelper.passwordValidator()
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraManager.cameraDevice = .Front
        self.cameraManager.addPreviewLayerToView(self.cameraView)
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
        
        T_DesignHelper.addRoundBorder(facebookLoginButton)
        T_DesignHelper.colorBorderButton(facebookLoginButton)
        
        T_DesignHelper.addRoundBorder(signUpButton)
        T_DesignHelper.colorBorderButton(signUpButton)
        
        T_DesignHelper.addRoundBorder(signInButton)
        T_DesignHelper.colorBorderButton(signInButton)
        
        T_DesignHelper.colorUIView(overlayView)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Actions
    @IBAction func loginFacebook(sender: AnyObject) {
        let permissions : [String]? = ["email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,name,email,first_name,last_name", parameters: nil)
                    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                        if error != nil {
                            // Process error
                            print("Error: \(error)")
                        }
                        else {
                            let email = result.valueForKey("email") as! String
                            let last_name = result.valueForKey("last_name") as! String
                            let first_name = result.valueForKey("first_name") as! String
                            user.username = email as String
                            let user = PFUser.currentUser() as! T_User?
                            user?.email = email
                            user?.lastName = last_name
                            user?.firstName = first_name
                            let storyboard = UIStoryboard(name: "Login", bundle: nil)
                            let vc = storyboard.instantiateViewControllerWithIdentifier("T_SignUpUsernameViaFacebookNavigationController") as! UINavigationController
                            self.presentViewController(vc, animated: true, completion: nil)
                            
                        }
                    })
                }
                else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @IBAction func signInTapped(sender: AnyObject) {
        usernameValidator.validate(usernameTextField.text, context: nil)
        passwordValidator.validate(passwordTextField.text, context: nil)
        let errors : [String] = T_ValidatorHelper.getAllErrors([usernameValidator, passwordValidator])
        if !errors.isEmpty {
            T_AlertHelper.alert(NSLocalizedString("Cannot sign in", comment: ""), errors: errors, viewController: self)
        }
        else {
            PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user : PFUser?, error : NSError? ) -> Void in
                    if let _ = user {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as UIViewController
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                    else {
                         T_AlertHelper.alert(NSLocalizedString("Cannot sign in", comment: ""), errors: [NSLocalizedString("Username and/or password incorect", comment: "")], viewController: self)
                    }
                }
       
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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
}


