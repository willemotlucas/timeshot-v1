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

    override init()
    {
        super.init()
    }
    
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
        self.cover = T_ParseUserHelper.fileFromImage(cover)
        self.createdBy = createdBy
        self.duration = duration
        self.isDeleted = isDeleted
        self.title = title
    }
        
    static func createAlbum(cover: UIImage, duration: Int, albumTitle: String) {
        
        if let currentUser = PFUser.currentUser() as? T_User {
           
            var attendees = T_User.selectedFriends
            attendees.append(currentUser)
            
            let album = T_Album(attendees: attendees, cover: cover, createdBy: currentUser, duration: duration, isDeleted: false, title: albumTitle)
            
            T_Album.albumCreationTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.albumCreationTask!)
            }

            album.saveInBackgroundWithBlock {
                (success, error) -> Void in
                if success {
                    print("Album created")
                    T_CameraViewController.instance.retrieveExistingAlbum()
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
    
    static func isALiveAlbumAlreadyExisting(withCompletion: (isExisting:Bool) -> ()) {
        
        // If internet connexion
        if let currentUser = PFUser.currentUser() as? T_User {
            let query = PFQuery(className: "Album")
            query.whereKey("attendees", equalTo: currentUser)
            query.orderByDescending("createdAt")
            query.limit = 1
            query.findObjectsInBackgroundWithBlock {
                (objects, error) -> Void in
                if error == nil {
                    
                    if (objects?.count == 1) {
                        let album = objects![0] as! T_Album
                        currentUser.liveAlbum = album
                        let creationDate = (album.createdAt)!
                        
                        if (!T_Album.isDurationExpired(creationDate, duration: album.duration)) {
                            album.pinInBackgroundWithName("liveAlbum")
                        }
                        else {
                            T_Album.unpinAllObjectsInBackgroundWithName("liveAlbum")
                        }
                        
                        withCompletion(isExisting: !T_Album.isDurationExpired(creationDate, duration: album.duration))
                    }
                    else {
                        withCompletion(isExisting: false)
                    }
                    
                } else { print("error") }
            }
        }
            // If no internet connexion, we take the album from localDataStore of Parse
        else {
            print("Not connected, cannot verify if an album is live")

//            if let currentUser = PFUser.currentUser() as? T_User {
//                let query = PFQuery(className: "Album")
//                query.fromLocalDatastore()
//                query.fromPinWithName("liveAlbum")
//                query.findObjectsInBackgroundWithBlock {
//                    (objects, error) -> Void in
//                    if error == nil {
//                        let album = objects![0] as! T_Album
//                        currentUser.liveAlbum = album
//                        let creationDate = (album.createdAt)!
//                        
//                        if (!T_Album.isDurationExpired(creationDate, duration: album.duration)) {
//                            album.pinInBackgroundWithName("liveAlbum")
//                        }
//                        else {
//                            T_Album.unpinAllObjectsInBackgroundWithName("liveAlbum")
//                        }
//                        
//                        withCompletion(isExisting: !T_Album.isDurationExpired(creationDate, duration: album.duration))
//                    }
//                }
//            }
        
        
        
        
        }
    }
    
    static func isDurationExpired(date:NSDate, duration: Int) -> Bool {
        if (getRemainingDuration(date, duration: duration) > 0) {
            return false
        }
        else {
            return true
        }
    }
    
    static func getDelay(date:NSDate) -> Int {
        return Int(-(date.timeIntervalSinceNow))
    }
    
    static func getRemainingDuration(date:NSDate, duration: Int) -> Int {
        return (duration*3600 - getDelay(date))
    }
    
    
}
