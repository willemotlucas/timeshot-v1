//
//  T_ContactsHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 22/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import SwiftAddressBook
import AddressBook
import AddressBookUI
import UIKit

class T_ContactsHelper {
    //static let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()

    /*
     * Display the request to access the address book
     * Params:
     * - @viewController : the view controller where will be displayed the request
     */
    static func promptForAddressBookRequestAccess(viewController: UIViewController) {
        SwiftAddressBook.requestAccessWithCompletion({ (success, error) -> Void in
            if success {
                viewController.performSegueWithIdentifier("showContactSearch", sender: nil)
            }
            else {
                self.displayCantAddContactAlert(viewController)
            }
        })
    }
    
    /*
     * Open iphone settings to Timeshot page to change right
     */
    static func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    /*
     * Display alert box to prevent user that the app doesn't have access to his contact
     * Params:
     * - @viewController : the view controller where will be displayed the alert
     */
    static func displayCantAddContactAlert(viewController: UIViewController) {
        let cantAddContactAlert = UIAlertController(title: "Cannot Add Contact",
            message: "You must give the app permission to add the contact first.",
            preferredStyle: .Alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
            style: .Default,
            handler: { action in
                self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        viewController.presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    
    /*
     * Retrieve all the contacts of the current user. We only keep the french number beginning by +33 or by 0
     * and we format the string to have format XX XX XX XX XX
     * Returns:
     * - [String:String] A map associating a user (full name) with the mobile phone
     */
    static func getAllContacts() -> [String:String] {
        var contactsWithNumbers = [String:String]()

        if let people = swiftAddressBook?.allPeople {
            for person in people {
                var contact = ""
                
                if let firstName = person.firstName {
                    contact += firstName
                }
                if let lastName = person.lastName {
                    contact += " " + lastName
                }
                
                let phoneNumbers = person.phoneNumbers?
                    .map({ $0.value.stringByReplacingOccurrencesOfString("+33", withString: "0").stringByReplacingOccurrencesOfString(" ", withString: "")} )
                    .filter({ return $0.characters.count == 10 })
                    .map({ $0.pairs.joinWithSeparator(" ")} )
                
                if let number = phoneNumbers?.first {
                    contactsWithNumbers[contact] = number
                    print("\(contact): \(phoneNumbers!.first!)")
                }
            }
        }
        
        return contactsWithNumbers
    }
}

extension String {
    var pairs: [String] {
        var result: [String] = []
        let chars = Array(characters)
        for index in 0.stride(to: chars.count, by: 2) {
            result.append(String(chars[index..<min(index+2, chars.count)]))
        }
        return result
    }
}