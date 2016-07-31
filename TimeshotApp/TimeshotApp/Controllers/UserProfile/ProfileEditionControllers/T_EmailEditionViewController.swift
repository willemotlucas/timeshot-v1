//
//  T_EmailEditionViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 10/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_EmailEditionViewController: UIViewController {
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var helpTextLabel: UILabel!
    
    var emailAddress = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.helpTextLabel.text = NSLocalizedString("Your email address is used to identify you. No spam, we promise ❤️", comment: "")
        self.helpTextLabel.numberOfLines = 3
        self.emailAddressTextField.text = self.emailAddress
        self.emailAddressTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        if Reachability.isConnectedToNetwork() {
            if self.emailAddressTextField.text!.isEmpty {
                self.helpTextLabel.textColor = UIColor.redColor()
                self.helpTextLabel.text = T_FormValidationHelper.EmptyEmailAddressError
            }
            else if !T_FormValidationHelper.isValidEmail(self.emailAddressTextField.text!) {
                self.helpTextLabel.textColor = UIColor.redColor()
                self.helpTextLabel.text = T_FormValidationHelper.InvalidEmailAddressError
            }
            else {
                T_ParseUserHelper.editEmail(self.emailAddressTextField.text!)
                navigationController?.popViewControllerAnimated(true)
            }
        } else {
            self.helpTextLabel.text = T_FormValidationHelper.NetworkError
            self.helpTextLabel.textColor = UIColor.redColor()
        }
    }
}
