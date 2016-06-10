//
//  T_ParseUserHelper.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 07/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

/*
 * Class T_ParseUserHelper
 * Provide methods to login, check login, edit user information ...
 */
class T_ParseUserHelper {
    // MARK: Parse User properties
    static let UserParseClass = "User"
    static let UsernameParse = "username"
    static let FirstNameParse = "firstName"
    static let LastNameParse = "lastName"
    static let BirthdayDateParse = "birthDate"
    static let EmailAddressParse = "email"
    
    // MARK: Login
    static func login(login: String, password: String, completionBlock : PFUserResultBlock?) {
            PFUser.logInWithUsernameInBackground(login, password: password, block: completionBlock)
            
        if (isLogged()) {
                print("Logged in successfully (from server) !")
                return
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
    
    /*
     * Retrieve all the users of Timeshot excluding the current user
     * Params:
     * - @completionBlock : the methods executed asynchroneously when all the users have been retrieved
     */
    static func gettAllUsers(completionBlock: PFQueryArrayResultBlock) {
        let query = PFUser.query()!
        query.whereKey(UsernameParse, notEqualTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    /**
     * Check if an email already exist
     * Params:
     * - @email : the email to check
     * Return : bool
     */
    static func emailAlreadyExist(email : String, _ completeBlock :PFQueryArrayResultBlock?) {
        let query = T_User.query()!
        //query.whereKey(self.EmailAddressParse, equalTo: email)
        query.whereKey(self.EmailAddressParse, matchesRegex: String(format:"(?i)\\b%@\\b", email))
        query.findObjectsInBackgroundWithBlock(completeBlock)
    }
    /**
     * Check if an username already exist
     * Params:
     * - @email : the username to check
     * Return : bool
     */
    static func usernameAlreadyExist(username : String, _ completeBlock :PFQueryArrayResultBlock?) {
        let query = T_User.query()!
        //query.whereKey(self.UsernameParse, equalTo: username)
        query.whereKey(self.UsernameParse, matchesRegex: String(format:"(?i)\\b%@\\b", username))
        query.findObjectsInBackgroundWithBlock(completeBlock)
    }
    
    // MARK: Edition functions
    
    /*
     * Save a new first name for the current user
     * Params:
     * - @firstName : the new first name to save
     */
    static func editFirstName(firstName: String) {
        getCurrentUser()!.setObject(firstName, forKey: FirstNameParse)
        getCurrentUser()!.saveInBackgroundWithBlock(nil)
    }
    
    /*
     * Save a new last name for the current user
     * Params:
     * - @lastName : the new last name to save
     */
    static func editLastName(lastName: String) {
        getCurrentUser()!.setObject(lastName, forKey: LastNameParse)
        getCurrentUser()!.saveInBackgroundWithBlock(nil)
    }
    
    /*
     * Save a new birthday for the current user
     * Params:
     * - @firstName : the new birthday to save
     */
    static func editBirthday(birthdayDate: NSDate) {
        getCurrentUser()!.setObject(birthdayDate, forKey: BirthdayDateParse)
        getCurrentUser()!.saveInBackgroundWithBlock(nil)
    }
    
    /*
     * Save a new email for the current user
     * Params:
     * - @firstName : the new email to save
     */
    static func editEmail(email: String) {
        getCurrentUser()!.setObject(email, forKey: EmailAddressParse)
        getCurrentUser()!.saveInBackgroundWithBlock(nil)
    }
}