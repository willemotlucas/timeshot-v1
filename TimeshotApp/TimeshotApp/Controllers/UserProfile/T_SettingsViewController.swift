//
//  T_SettingsViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 20/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse

class T_SettingsViewController: UITableViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var currentUser: T_User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentUser = PFUser.currentUser()! as! T_User
        
        //Set label information of the current user to display in static cell of the table view
        self.usernameLabel.text = currentUser.username!
        self.firstNameLabel.text = currentUser.firstName!
        self.lastNameLabel.text = currentUser.lastName!
        self.emailLabel.text = currentUser.email!
        if let birthday = currentUser.birthDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.birthdayLabel.text = dateFormatter.stringFromDate(birthday)
        } else {
            self.birthdayLabel.text = ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "firstNameEditionSegue" {
            if let destinationVC = segue.destinationViewController as? T_FirstNameEditionViewController {
                destinationVC.firstName = self.firstNameLabel.text!
            }
        } else if segue.identifier == "lastNameEditionSegue" {
            if let destinationVC = segue.destinationViewController as? T_LastNameEditionViewController {
                destinationVC.lastName = self.lastNameLabel.text!
            }
        } else if segue.identifier == "birthdayEditionSegue" {
            if let destinationVC = segue.destinationViewController as? T_BirthdayEditionViewController {
                destinationVC.birthdayDate = self.birthdayLabel.text!
            }
        } else if segue.identifier == "emailEditionSegue" {
            if let destinationVC = segue.destinationViewController as? T_EmailEditionViewController {
                destinationVC.emailAddress = self.emailLabel.text!
            }
        }
    }
    

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
