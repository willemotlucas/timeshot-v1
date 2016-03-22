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
                    let personViewController = ABPeoplePickerNavigationController()
                    viewController.presentViewController(personViewController, animated: true, completion: nil)
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
}