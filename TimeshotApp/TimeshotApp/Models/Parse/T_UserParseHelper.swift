//
//  T_UserParseHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 09/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_UserParseHelper {
    static let UserParseClass = "User"
    static let UsernameParse = "username"
    static let FirstNameParse = "firstName"
    static let LastNameParse = "lastName"
    static let BirthdayDateParse = "birthDate"
    
    static let currentUser = PFUser.currentUser() as! T_User
    
    static func gettAllUsers(completionBlock: PFQueryArrayResultBlock) {
        let query = PFUser.query()!
        query.whereKey(UsernameParse, notEqualTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func editFirstName(firstName: String) {
        self.currentUser.setObject(firstName, forKey: FirstNameParse)
        self.currentUser.saveInBackgroundWithBlock(nil)
    }
    
    static func editLastName(lastName: String) {
        self.currentUser.setObject(lastName, forKey: LastNameParse)
        self.currentUser.saveInBackgroundWithBlock(nil)
    }
    
    static func editBirthday(birthdayDate: NSDate) {
        self.currentUser.setObject(birthdayDate, forKey: BirthdayDateParse)
        self.currentUser.saveInBackgroundWithBlock(nil)
    }
}