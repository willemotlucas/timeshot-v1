//
//  FirstNameEditionViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 09/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_FirstNameEditionViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var helpTextLabel: UILabel!
    
    var firstName = ""

    override func viewWillAppear(animated: Bool) {
        self.firstNameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameTextField.text = firstName
        self.helpTextLabel.text = "Your first name helps your friends to find you 😊"
        self.helpTextLabel.numberOfLines = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        if self.firstNameTextField.text?.characters.count >= 3{
            if(self.firstNameTextField.text != self.firstName) {
                T_UserParseHelper.editFirstName(self.firstNameTextField.text!)
            }
            navigationController?.popViewControllerAnimated(true)
        } else {
            self.helpTextLabel.text = "Don't be ridiculous, this first name is too short 😉"
            self.helpTextLabel.textColor = UIColor.redColor()
        }
    }
}
