//
//  T_Friend.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 05/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_User : PFUser {
    
    @NSManaged var emailVerified:Bool
    @NSManaged var birthDate:NSDate?
    @NSManaged var firstName:String?
    @NSManaged var lastName:String?
    @NSManaged var isDeleted:Bool
    
    
    
    //MARK: PFSubclassing Protocol
    override init () {
        super.init()
    }
    
    init(username: String, password:String, birthDate:NSDate, email:String, firstName:String, lastName:String)
    {
        super.init()
        
        self.username = username
        self.password = password
        self.birthDate = birthDate
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.isDeleted = false
    }
    
    init(username: String, birthDate:NSDate, email:String, firstName:String, lastName:String)
    {
        super.init()
        
        self.username = username
        self.birthDate = birthDate
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.isDeleted = false
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func createUser()
    {
        saveInBackgroundWithBlock(nil)
    }
    
}
