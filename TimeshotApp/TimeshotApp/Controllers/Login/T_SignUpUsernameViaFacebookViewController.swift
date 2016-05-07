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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = T_User.currentUser()
        // Do any additional setup after loading the view.
        if let navbar = self.navigationController?.navigationBar {
            T_DesignHelper.colorNavBar(navbar)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === continueButton {
            if let signupInviteView = segue.destinationViewController as? T_SignUpInvitePeopleViewController {
                let username : String? = usernameTextField.text
                if let user = user {
                    user.username = username
                    signupInviteView.user = user
                    signupInviteView.viaFacebook = true
                }
            }
            
        }
    }
}
