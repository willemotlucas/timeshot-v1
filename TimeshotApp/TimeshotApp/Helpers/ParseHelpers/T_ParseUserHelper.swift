//
//  T_ParseUserHelper.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 07/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_ParseUserHelper {
    // MARK: Parse User properties
    static let UserParseClass = "User"
    static let UsernameParse = "username"
    static let FirstNameParse = "firstName"
    static let LastNameParse = "lastName"
    static let BirthdayDateParse = "birthDate"
    static let EmailAddressParse = "email"
    
    // MARK: Login
    static func login(login: String, password: String) {
        do {
            try PFUser.logInWithUsername(login, password: password)
            
            if (isLogged()) {
                print("Logged in successfully (from server) !")
                return
            }
        }
        catch {
            if (isLogged()) {
                print("Logged in successfully (from cache) !")
                return
            }
        }
        
        print("Not logged : should not go further in the app !")
    }
    
    static func isLogged() -> Bool {
        if (PFUser.currentUser() != nil) {
            return true
        }
        else {
            return false
        }
    }
    
    //MARK: Utils
    static func fileFromImage(image: UIImage) -> PFFile {
        return PFFile(data: UIImageJPEGRepresentation(image, 1.0)!)!
    }
    
    static func getUserFromObjects(objects: [PFObject]?) -> T_User? {
        if (objects?.count == 1) {
            return objects![0] as? T_User
        }
        else {
            return nil
        }
    }
    
    static func queryUserPinned(withCompletion: (currentUser: T_User?) -> ()) {
        
        let query = T_User.query()
        query!.fromLocalDatastore()
        query!.fromPinWithName("currentUser")
        query!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if (error == nil)
            {
                withCompletion(currentUser: getUserFromObjects(objects))
            }
            else
            {
                print("error to find User locally in background")
                withCompletion(currentUser: nil)
            }
        }
    }
    
    static func getCurrentUser() -> T_User? {
        return PFUser.currentUser() as! T_User?
    }
    
    // MARK: Requests
    static func gettAllUsers(completionBlock: PFQueryArrayResultBlock) {
        let query = PFUser.query()!
        query.whereKey(UsernameParse, notEqualTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // MARK: Edition functions
    static func editFirstName(firstName: String) {
        getCurrentUser()!.setObject(firstName, forKey: FirstNameParse)
        getCurrentUser()!.saveInBackgroundWithBlock(nil)
    }
    
    static func editLastName(lastName: String) {
        getCurrentUser()!.setObject(lastName, forKey: LastNameParse)
        getCurrentUser()!.saveInBackgroundWithBlock(nil)
    }
    
    static func editBirthday(birthdayDate: NSDate) {
        getCurrentUser()!.setObject(birthdayDate, forKey: BirthdayDateParse)
        getCurrentUser()!.saveInBackgroundWithBlock(nil)
    }
    
    static func editEmail(email: String) {
        getCurrentUser()!.setObject(email, forKey: EmailAddressParse)
        getCurrentUser()!.saveInBackgroundWithBlock(nil)
    }
}