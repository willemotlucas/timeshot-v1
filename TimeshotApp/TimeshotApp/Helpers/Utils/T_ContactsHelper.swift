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

    static func promptForAddressBookRequestAccess(viewController: UIViewController) {
        var err: Unmanaged<CFError>? = nil
        
        ABAddressBookRequestAccessWithCompletion(self.addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    self.displayCantAddContactAlert(viewController)
                } else {
                    viewController.performSegueWithIdentifier("showContactSearch", sender: nil)
                }
            }
        }
    }
    
    static func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
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
                        if let firstName = ABRecordCopyValue(contactRef, kABPersonFirstNameProperty).takeRetainedValue() as? NSString {
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