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

class T_Album : PFObject, PFSubclassing {
    // MARK: Properties
    @NSManaged var attendees: [T_User]
    @NSManaged var cover: PFFile
    @NSManaged var createdBy: T_User
    @NSManaged var duration: Int
    @NSManaged var isDeleted: Bool
    @NSManaged var title: String
    
    var coverImage : Observable<UIImage?> = Observable(nil)
    
    static var albumCreationTask: UIBackgroundTaskIdentifier?
    
    // MARK: Initialisation
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
    
    init(attendees: [T_User], cover:UIImage, createdBy:T_User, duration:Int, isDeleted:Bool, title:String) {
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
                    T_CameraViewController.instance.manageAlbumProcessing()
                } else {
                    print("An error occured : %@", error)
                }
                T_CameraViewController.instance.unfreezeUI()
                UIApplication.sharedApplication().endBackgroundTask(self.albumCreationTask!)
            }
        }
        else {
            print("Not connected, cannot create the album")
        }
    }
    
    static func manageAlbumProcessing(currentUser: T_User, withCompletion completion: (isLiveAlbum: Bool) -> Void) {
        
        print("\n\n\nProcessing\n-----")
        // Y'a t'il un album dans currentUser.liveAlbum NON EXPIRÉ ?
        if (isLiveAlbumAssociatedToUser(currentUser.liveAlbum)) {
            print("Album found in T_User")
            completion(isLiveAlbum: true)
            return
        }
        else {
            currentUser.liveAlbum = nil
            isLiveAlbumFetchInBackground(currentUser, withCompletion: completion)
            return
        }
    }
    
    //------------------------------------------------------------------------------------------
    //MARK: - Album live detection methods
    static func isLiveAlbumAssociatedToUser(optionnalAlbum: T_Album?) -> Bool {
        
        guard let album = optionnalAlbum where isAlbumInLive(album) else { return false }
        
        T_ParseAlbumHelper.pinLocallyAlbum(album)
        
        return true
    }
    
    static func isLiveAlbumFetchInBackground(currentUser: T_User, withCompletion completion: (isLiveAlbum: Bool) -> Void) {
        
        isLiveAlbumPinned(currentUser, withEndCompletion: completion) {
            (currentUser: T_User) -> Void in
            
            isLiveAlbumOnParse(currentUser, withEndCompletion: completion)
        }
    }
    
    //----------------
    static func isLiveAlbumPinned(currentUser: T_User, withEndCompletion endCompletion: (isLiveAlbum: Bool) -> Void, withDeeperCompletion completion: (currentUser: T_User) -> Void) {
        
        T_ParseAlbumHelper.queryAlbumPinned {
            (liveAlbum: T_Album?) -> () in
        
            currentUser.liveAlbum = liveAlbum
            
            if (isLiveAlbumAssociatedToUser(currentUser.liveAlbum)) {
                print("Found pinned in local data")
                endCompletion(isLiveAlbum: true)
                return
            }
            
            completion(currentUser: currentUser)
        }
        
    }
    
    static func isLiveAlbumOnParse(currentUser: T_User, withEndCompletion endCompletion: (isLiveAlbum: Bool) -> Void) -> () {
        
        T_ParseAlbumHelper.queryLastAlbumOnParse(currentUser) {
            (liveAlbum: T_Album?) -> () in
            
            currentUser.liveAlbum = liveAlbum
            
            if (isLiveAlbumAssociatedToUser(currentUser.liveAlbum)) {
                print("Found on parse online")
                endCompletion(isLiveAlbum: true)
                return
            }
        }
    }
    
    //------------------------------------------------------------------------------------------
    //MARK: - Tools
    static func isAlbumInLive(album: T_Album) -> Bool {
        
        return !isDurationExpired(album.createdAt!, duration: album.duration)
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
    
    //------------------------------------------------------------------------------------------
    // MARK: Download Cover Image
    func downloadCoverImage() {
        // if cover is not downloaded yet, get it
        if coverImage.value == nil {
            // In background to not block the main thread
            cover.getDataInBackgroundWithBlock { (data: NSData?, error:NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data:data, scale: 1.0)!
                    // .value because it's an observable
                    self.coverImage.value = image
                }
                
            }
        }
    }
}
