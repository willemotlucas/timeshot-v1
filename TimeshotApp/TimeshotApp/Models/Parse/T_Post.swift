//
//  T_Album.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 07/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit

class T_Post : PFObject, PFSubclassing {
    
    @NSManaged var fromUser: T_User
    @NSManaged var photo: PFFile
    @NSManaged var toAlbum: T_Album
    @NSManaged var isDeleted: Bool
    @NSManaged var createdAtDate: NSDate
    @NSManaged var hasVoted: [T_User]
    
    var image : Observable<UIImage?> = Observable(nil)
    
    
    static var postCreationTask: UIBackgroundTaskIdentifier?
    static var imageCache: NSCacheSwift<String, UIImage>!
    
    override init(){
        super.init()
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
            T_Post.imageCache = NSCacheSwift<String, UIImage>()
        }
    }
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    init(fromUser: T_User, photo:UIImage, toAlbum:T_Album, hasVoted:[T_User])
    {
        super.init()
        
        self.fromUser = fromUser
        self.photo = T_ParseUserHelper.fileFromImage(photo)
        self.toAlbum = toAlbum
        self.isDeleted = false
        self.createdAtDate = NSDate()
        self.hasVoted = hasVoted
    }
    
    init(fromUser: T_User, toAlbum:T_Album, hasVoted:[T_User])
    {
        super.init()
        
        self.fromUser = fromUser
        self.toAlbum = toAlbum
        self.isDeleted = false
        self.createdAtDate = NSDate()
        self.hasVoted = hasVoted
    }

    
    static func createAndUploadPost(picture: UIImage) {
        
        guard let currentUser = PFUser.currentUser() as? T_User where currentUser.liveAlbum != nil else {
            print("Not connected, cannot create the post")
            return
        }

        let post = T_Post(fromUser: currentUser, photo: picture, toAlbum: currentUser.liveAlbum!, hasVoted: [currentUser])
        uploadPost(post)
    }
    
    static func createPost() -> T_Post {
        
        return T_Post(fromUser: T_ParseUserHelper.getCurrentUser()!, toAlbum: T_ParseUserHelper.getCurrentUser()!.liveAlbum!,hasVoted: [T_ParseUserHelper.getCurrentUser()!])
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
    
    

    func downloadImage() {
        // if image is not downloaded yet, get it
        if (image.value == nil) {
            // We check if we have the image in the cache
            image.value = T_Post.imageCache[self.photo.name]
            
            // if not, we dowload it from Parse
            if(image.value == nil) {
                //print("imageValue:\(image.value)")
                photo.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                    if let data = data {
                        let image = UIImage(data: data, scale:1.0)!
                        // 3
                        self.image.value = image
                        T_Post.imageCache[self.photo.name] = image
                    }
                }
            }
        }
    }
    
    
}
