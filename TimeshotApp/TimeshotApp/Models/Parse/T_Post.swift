//
//  T_Album.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 07/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_Post : PFObject, PFSubclassing {
    
    @NSManaged var fromUser: T_User
    @NSManaged var photo: PFFile
    @NSManaged var toAlbum: T_Album
    @NSManaged var isDeleted: Bool
    
    static var postCreationTask: UIBackgroundTaskIdentifier?
    
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
        return "Post"
    }
    
    init(fromUser: T_User, photo:UIImage, toAlbum:T_Album)
    {
        super.init()
        
        self.fromUser = fromUser
        self.photo = T_ParseUserHelper.fileFromImage(photo)
        self.toAlbum = toAlbum
        self.isDeleted = false
    }
    
    static func createPost(picture: UIImage) {
        
        if let currentUser = PFUser.currentUser() as? T_User {
            
            if let currentLiveAlbum = currentUser.liveAlbum as T_Album? {
        
                let post = T_Post(fromUser: currentUser, photo: picture, toAlbum: currentLiveAlbum)
                
                T_Post.postCreationTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                    UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
                }
                
                post.saveInBackgroundWithBlock {
                    (success, error) -> Void in
                    if success {
                        print("Post created")
                    } else {
                        print("An error occured : %@", error)
                    }
                    UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
                }
            }
        }
        else {
            print("Not connected, cannot create the album")
        }
    }
}
