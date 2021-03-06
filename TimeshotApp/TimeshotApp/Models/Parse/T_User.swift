//
//  T_Friend.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 05/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit

class T_User : PFUser {
    
    @NSManaged var emailVerified:Bool
    @NSManaged var birthDate:NSDate?
    @NSManaged var firstName:String?
    @NSManaged var lastName:String?
    @NSManaged var isDeleted:Bool
    @NSManaged var picture:PFFile?
    
    var image: Observable<UIImage?> = Observable(nil)
    var liveAlbum:T_Album?
    var albums:[T_Album] = []
    var friends: [T_User] = []
    var pendingFriends: [T_User] = []
    
    static var albumListCache: NSCacheSwift<String, [T_Album]>!
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    static var selectedFriends:[T_User] = []
    
    private
    var selected:Bool
    
    //MARK: PFSubclassing Protocol
    override init () {
        self.selected = false
        
        super.init()
    }
    
    init(username: String, password:String, birthDate:NSDate, email:String, firstName:String, lastName:String, picture:PFFile)
    {
        self.selected = false
        super.init()
        
        self.username = username
        self.password = password
        self.birthDate = birthDate
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.isDeleted = false
        self.picture = picture
    }
    
    init(username: String, password:String, birthDate:NSDate, email:String, firstName:String, lastName:String, image:UIImage)
    {
        self.selected = false
        
        super.init()
        
        self.username = username
        self.password = password
        self.birthDate = birthDate
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.isDeleted = false
        self.picture = T_ParseUserHelper.fileFromImage(image)
    }
    
    init(username: String, birthDate:NSDate, email:String, firstName:String, lastName:String)
    {
        self.selected = false
        
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
        T_User.albumListCache = NSCacheSwift<String, [T_Album]>()
        
    }
    
    func changeStateFriendSelected()
    {
        if(self.selected)
        {
            self.selected = false
            
            if let index = T_User.selectedFriends.indexOf(self)
            {
                T_User.selectedFriends.removeAtIndex(index)
            }
        }
        else {
            self.selected = true
            if (T_User.selectedFriends.indexOf(self) == nil)
            {
                T_User.selectedFriends.append(self)
            }
        }
    }
    
    func isSelected() -> Bool
    {
        return selected
    }
    
    static func reset() {
        selectedFriends.removeAll()
    }
    
    func downloadImage() {
        if (image.value == nil) {
            //Set a default profile picture
            let image = UIImage(named: "default-friend-picture")
            self.image.value = image
            
            //If there is a profile picture provided by the user, it will be used
            picture?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    self.image.value = image
                }
            }
        }
    }
    
    func uploadImage() {
        if let image = self.image.value {
            let imageData = UIImageJPEGRepresentation(image, 0.8)!
            let imageFile = PFFile(data: imageData)
            
            // Create a photo upload task to avoid uploading to be cancelled if user quit the app
            // In other words, we request extra time to finish uploading the image to Parse
            // It returns a unique ID that we store in photoUploadTask property
            self.photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                // In case the extra time iOS give us is finish, we terminate the photoUploadTask
                // Otherwise, the app will be canceled!
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            imageFile!.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                // When photo uploading is finished, we terminate the photo upload task
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            self.picture = imageFile
            saveInBackgroundWithBlock(nil)
        }
    }
    
    func getAllFriends(completion: (friends: [T_User]) -> Void) {
        if let currentUser = T_ParseUserHelper.getCurrentUser() {
            if currentUser.friends.isEmpty {
                getAllFriendsFromParse(completion)
            }else {
                completion(friends: currentUser.friends)
            }
        }
    }
    
    func getAllFriendsFromParse(completion: (friends: [T_User]) -> Void) {
        T_FriendRequestParseHelper.getFriendsFromAcceptedRequests({ (friends) in
            self.friends = friends
            completion(friends: friends)
        })
    }
    
    func getAllPendingFriends(completion: (friends: [T_User]) -> Void) {
        if self.pendingFriends.isEmpty {
            T_FriendRequestParseHelper.getFriendsFromPendingRequest({ (friends) in
                self.pendingFriends = friends
                completion(friends: friends)
            })
        }else {
            completion(friends: self.pendingFriends)
        }
    }
    
    
    static func getAllUsers(withCompletion: (data: [T_User]) -> ())
    {
        let query = T_User.query()
        query!.selectKeys(["firstName", "lastName", "picture"])
        query!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                withCompletion(data: objects as! [T_User])
            }
            else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    static func getAllAlbums(withCompletion: (data: [T_User]) -> ())
    {
        let query = T_User.query()
        query!.selectKeys(["firstName", "lastName", "picture"])
        query!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                withCompletion(data: objects as! [T_User])
            }
            else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
}

