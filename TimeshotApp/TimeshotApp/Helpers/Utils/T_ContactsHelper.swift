//
//  T_ContactsHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 22/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI
import UIKit

class T_ContactsHelper {
    static let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()

    /*
     * Display the request to access the address book
     * Params:
     * - @viewController : the view controller where will be displayed the request
     */
    static func promptForAddressBookRequestAccess(viewController: UIViewController) {
        var err: Unmanaged<CFError>? = nil
        
        ABAddressBookRequestAccessWithCompletion(self.addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    self.displayCantAddContactAlert(viewController)
                } else {
                    // User has accepted access to his address book
                    viewController.performSegueWithIdentifier("showContactSearch", sender: nil)
                }
            }
        }
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
        let contactsRef: NSArray = ABAddressBookCopyArrayOfAllPeople(T_ContactsHelper.addressBookRef).takeRetainedValue()
        
        for contactRef:ABRecordRef in contactsRef {
            //Get all the phone numbers of the current contact
            if let telNumberRefs:ABMultiValueRef = ABRecordCopyValue(contactRef, kABPersonPhoneProperty).takeRetainedValue() {
                //We continue only if we find a phone number
                if(ABMultiValueGetCount(telNumberRefs) > 0) {
                    //We get the phone number as a string
                    let value = ABMultiValueCopyValueAtIndex(telNumberRefs,0).takeRetainedValue() as! NSString
                    var telNumber = String(value)
                    //We format the string to replace +33 by 0
                    telNumber = telNumber.stringByReplacingOccurrencesOfString("+33", withString: "0").stringByReplacingOccurrencesOfString(" ", withString: "")
                    
                    //We continue only if the phone number has 10 characters, otherwise it is wrong
                    if telNumber.characters.count == 10 {
                        //We add a space to format the string to : xx xx xx xx xx
                        for var i=2; i <= 14; i+=3 {
                            telNumber.insert(" " as Character, atIndex: telNumber.startIndex.advancedBy(i))
                        }
                        
                        //We get the first name associated with the phone number
                        if let firstName = ABRecordCopyValue(contactRef, kABPersonFirstNameProperty)?.takeRetainedValue() as? NSString {
                            //We get the last name associated with the phone number
                            if let lastNameRef = ABRecordCopyValue(contactRef, kABPersonLastNameProperty) {
                                let lastName = lastNameRef.takeRetainedValue() as! NSString
                                //We construct the full name
                                let fullName = String(firstName) + " " + String(lastName)
                                contactsWithNumbers[fullName] = telNumber
                            } else {
                                //We don't find a last name so we just keep the first name
                                contactsWithNumbers[String(firstName)] = telNumber
                            }
                        }
                    }
                }
            }
        }
        
        return contactsWithNumbers
    }
}