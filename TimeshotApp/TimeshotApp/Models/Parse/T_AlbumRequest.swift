//
//  T_AlbumRequest.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 30/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_AlbumRequest: PFObject, PFSubclassing {
    @NSManaged var fromUser: T_User?
    @NSManaged var toUser: T_User?
    @NSManaged var status: String?
    @NSManaged var toAlbum: T_Album?
    
    static func parseClassName() -> String {
        return "AlbumRequest"
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
    
    init(toUser: T_User, toAlbum: T_Album){
        super.init()
        self.fromUser = T_ParseUserHelper.getCurrentUser()!
        self.toUser = toUser
        self.toAlbum = toAlbum
        self.status = "Pending"
    }
}
