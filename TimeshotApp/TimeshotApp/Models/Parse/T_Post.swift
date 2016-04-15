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
    
    var image : UIImage?
    
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
    
    init(fromUser: T_User, toAlbum:T_Album)
    {
        super.init()
        
        self.fromUser = fromUser
        self.toAlbum = toAlbum
        self.isDeleted = false
    }

    
    static func createAndUploadPost(picture: UIImage) {
        
        guard let currentUser = PFUser.currentUser() as? T_User where currentUser.liveAlbum != nil else {
            print("Not connected, cannot create the post")
            return
        }

        let post = T_Post(fromUser: currentUser, photo: picture, toAlbum: currentUser.liveAlbum!)
        uploadPost(post)
    }
    
    static func createPost() -> T_Post {
        
        return T_Post(fromUser: T_ParseUserHelper.getCurrentUser()!, toAlbum: T_ParseUserHelper.getCurrentUser()!.liveAlbum!)
    }
    
    func addPictureToPost(picture: UIImage) {
        self.photo = T_ParseUserHelper.fileFromImage(picture)
    }
    
    static func uploadPost(post: T_Post) {
        
        guard let currentUser = PFUser.currentUser() as? T_User where currentUser.liveAlbum != nil else {
            print("Not connected, cannot create the post")
            return
        }
        
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
