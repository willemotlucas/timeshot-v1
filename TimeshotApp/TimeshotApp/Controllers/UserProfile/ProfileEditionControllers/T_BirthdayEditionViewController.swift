//
//  BirthdayEditionViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 09/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_BirthdayEditionViewController: UIViewController {
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var helpTextLabel: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    var birthdayDate = ""
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.birthdayTextField.enabled = false
        
        self.helpTextLabel.text = "You must be 13 years old at least 🎂"
        self.helpTextLabel.numberOfLines = 2
        self.birthdayDatePicker.maximumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -13, toDate: NSDate(), options: [])
        
        if !self.birthdayDate.isEmpty {
            self.birthdayDatePicker.date = self.dateFormatter.dateFromString(self.birthdayDate)!
            self.birthdayTextField.text = birthdayDate
        } else {
            self.birthdayDatePicker.date = self.birthdayDatePicker.maximumDate!
            self.birthdayTextField.text = self.dateFormatter.stringFromDate(self.birthdayDatePicker.maximumDate!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectedDateChanged(sender: UIDatePicker) {
        let strDate = self.dateFormatter.stringFromDate(birthdayDatePicker.date)
        self.birthdayTextField.text = strDate
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        if Reachability.isConnectedToNetwork() {
            if let birthString = self.birthdayTextField.text {
                let birthDate = self.dateFormatter.dateFromString(birthString)
                T_ParseUserHelper.editBirthday(birthDate!)
                navigationController?.popViewControllerAnimated(true)
            }
        } else {
            self.helpTextLabel.text = T_FormValidationHelper.NetworkError
            self.helpTextLabel.textColor = UIColor.redColor()
        }
    }
}
