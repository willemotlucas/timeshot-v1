//
//  T_Album.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 07/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_Album : PFObject, PFSubclassing {
    
    @NSManaged var attendees: [T_User]
    @NSManaged var cover: PFFile
    @NSManaged var createdBy: T_User
    @NSManaged var duration: Int
    @NSManaged var isDeleted: Bool
    @NSManaged var title: String
    
    static var albumCreationTask: UIBackgroundTaskIdentifier?

    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Album"
    }
    
    init(attendees: [T_User], cover:UIImage, createdBy:T_User, duration:Int, isDeleted:Bool, title:String)
    {
        super.init()
        
        self.attendees = attendees
        self.cover = PFFileFromImage(cover)
        self.createdBy = createdBy
        self.duration = duration
        self.isDeleted = isDeleted
        self.title = title
    }
    
    func PFFileFromImage(image: UIImage) -> PFFile {
        return T_ParseUserHelper.fileFromImage(image)
    }
    
    static func createAlbum(cover: UIImage, duration: Int, albumTitle: String) {
        
        if let currentUser = PFUser.currentUser() as? T_User {
           
            let album = T_Album(attendees: T_User.selectedFriends, cover: cover, createdBy: currentUser, duration: duration, isDeleted: false, title: albumTitle)
            
            T_Album.albumCreationTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.albumCreationTask!)
            }

            album.saveInBackgroundWithBlock {
                (success, error) -> Void in
                if success {
                    print("Album created")
                } else {
                    print("An error occured : %@", error)
                }
                UIApplication.sharedApplication().endBackgroundTask(self.albumCreationTask!)
            }
        }
        else {
            print("Not connected, cannot create the album")
        }
    }
    
    
    
    
}
