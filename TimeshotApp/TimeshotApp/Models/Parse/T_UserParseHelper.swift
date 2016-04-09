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
    
    static func gettAllUsers(completionBlock: PFQueryArrayResultBlock){
        let query = PFUser.query()!
        query.whereKey(UsernameParse, notEqualTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func editFirstName(firstName: String){
        let currentUser = PFUser.currentUser()! as! T_User
        currentUser.setObject(firstName, forKey: FirstNameParse)
        currentUser.saveInBackgroundWithBlock(nil)
    }
}