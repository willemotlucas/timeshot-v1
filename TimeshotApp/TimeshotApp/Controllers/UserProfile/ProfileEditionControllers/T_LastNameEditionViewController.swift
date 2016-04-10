//
//  LastNameEditionViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 09/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_LastNameEditionViewController: UIViewController {
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var helpTextLabel: UILabel!

    var lastName = ""
    
    override func viewWillAppear(animated: Bool) {
        self.lastNameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lastNameTextField.text = lastName
        self.helpTextLabel.text = "Your last name helps your friends to find you 😊"
        self.helpTextLabel.numberOfLines = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        if self.lastNameTextField.text?.characters.count >= T_FormValidationHelper.LastNameMinCharacter{
            if(self.lastNameTextField.text != self.lastName) {
                T_UserParseHelper.editLastName(self.lastNameTextField.text!)
            }
            navigationController?.popViewControllerAnimated(true)
        } else {
            self.helpTextLabel.text = T_FormValidationHelper.LastNameMinCharacterError
            self.helpTextLabel.textColor = UIColor.redColor()
        }
    }
}
