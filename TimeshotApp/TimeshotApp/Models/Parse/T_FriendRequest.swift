//
//  T_FriendRequest.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 08/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_FriendRequest: PFObject, PFSubclassing {
    @NSManaged var fromUser: PFUser?
    @NSManaged var toUser: PFUser?
    @NSManaged var status: String?
    
    static func parseClassName() -> String {
        return "FriendRequest"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // Inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    init(toUser: T_User){
        super.init()
        self.fromUser = PFUser.currentUser()!
        self.toUser = toUser
        self.status = "Pending"
    }
}
