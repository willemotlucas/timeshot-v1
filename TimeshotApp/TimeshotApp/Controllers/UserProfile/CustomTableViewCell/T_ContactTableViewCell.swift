//
//  T_ContactTableViewCell.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 23/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactTelephoneLabel: UILabel!
    @IBOutlet weak var checkboxButton: T_SendMessageUIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*@IBAction func addContactButtonTapped(sender: UIButton) {
        print(self.contactTelephoneLabel.text!)
        print(self.contactNameLabel.text!)
        
        let messageVC = MFMessageComposeViewController()
        
        if((delegate?.respondsToSelector("loadNewScreen:")) != nil)
        {
            messageVC.body = "Join me on Timeshot :)";
            messageVC.recipients = [self.contactNameLabel.text!]
            //messageVC.messageComposeDelegate = delegate;
            delegate?.loadNewScreen(messageVC);
        }*/
}
