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

class T_Album : PFObject, PFSubclassing{
    // MARK: Properties
    @NSManaged var attendees: [T_User]
    @NSManaged var cover: PFFile
    @NSManaged var createdBy: T_User
    @NSManaged var duration: Int
    @NSManaged var isDeleted: Bool
    @NSManaged var title: String!
    
    var coverImage : Observable<UIImage?> = Observable(nil)
    
    static var albumCreationTask: UIBackgroundTaskIdentifier?
    
    // On est interessé pour garder en cache la cover de l'album
    static var coverImageCache: NSCacheSwift<String, UIImage>!
    static var detailAlbumCache: NSCacheSwift<String,[T_Post]>!
    
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
            T_Album.coverImageCache = NSCacheSwift<String, UIImage>()
            T_Album.detailAlbumCache = NSCacheSwift<String, [T_Post]>()
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
            
            let guests = T_User.selectedFriends
            let attendees = [currentUser]
            let album = T_Album(attendees: attendees, cover: cover, createdBy: currentUser, duration: duration, isDeleted: false, title: albumTitle)
            
            for guest in guests {
                T_ParseAlbumRequestHelper.sendAlbumRequestNotification(guest)
                T_ParseAlbumRequestHelper.sendFriendRequest(guest, toAlbum: album)
            }
            
            T_Album.albumCreationTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.albumCreationTask!)
            }
            
            album.saveInBackgroundWithBlock {
                (success, error) -> Void in
                if success {
                    print("Album created")
                    
                    currentUser.liveAlbum = album
                    currentUser.albums.insert(album, atIndex: 0)
                    
                    T_CameraViewController.instance.manageAlbumProcessing()
                    T_CameraViewController.instance.unfreezeUI(true)
                } else {
                    T_CameraViewController.instance.unfreezeUI(false)
                    print("An error occured : %@", error)
                }
                UIApplication.sharedApplication().endBackgroundTask(self.albumCreationTask!)
            }
        }
        else {
            print("Not connected, cannot create the album")
        }
    }
    
    //MARK: Multi Album
    
    static func manageAlbumsProcessing(currentUser: T_User, withCompletion completion: (isLiveAlbum: Bool) -> Void) {
        
        print("\n\n\nProcessing\n-----")
        
        if (currentUser.liveAlbum != nil) {
            
            var finalAlbums:[T_Album] = []
            
            for album in currentUser.albums {
                if (isAlbumInLive(album)) {
                    finalAlbums.append(album)
                }
            }
            
            if (finalAlbums.count > 0) {
                T_ParseAlbumHelper.unpinLocalAlbum()
                for album in finalAlbums {
                    T_ParseAlbumHelper.pinLocalAlbum(album)
                }
                
                currentUser.albums.removeAll()
                currentUser.albums.appendContentsOf(finalAlbums)
                print("Albums found in T_User")
                completion(isLiveAlbum: true)
            }
            else {
                currentUser.liveAlbum = nil
                currentUser.albums.removeAll()
                isLiveAlbumsFetchInBackground(currentUser, withCompletion: completion)
            }
        }
        else {
            currentUser.liveAlbum = nil
            currentUser.albums.removeAll()
            isLiveAlbumsFetchInBackground(currentUser, withCompletion: completion)
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
    
    static func isLiveAlbumsFetchInBackground(currentUser: T_User, withCompletion completion: (isLiveAlbum: Bool) -> Void) {
        
        isLiveAlbumsPinned(currentUser, withEndCompletion: completion) {
            (currentUser: T_User) -> Void in
            
            isLiveAlbumsOnParse(currentUser, withEndCompletion: completion)
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
    
    // MultiAlbum
    static func isLiveAlbumsPinned(currentUser: T_User, withEndCompletion endCompletion: (isLiveAlbum: Bool) -> Void, withDeeperCompletion completion: (currentUser: T_User) -> Void) {
        
        T_ParseAlbumHelper.queryAlbumsPinned {
            (liveAlbum: [T_Album]) -> () in
            
            if (liveAlbum.count > 0) {
                currentUser.liveAlbum = liveAlbum.first
                currentUser.albums.removeAll()
                currentUser.albums.appendContentsOf(liveAlbum)
                
                print("Albums found pinned in local data")
                print(liveAlbum.count)
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
    
    // MultiAlbum
    static func isLiveAlbumsOnParse(currentUser: T_User, withEndCompletion endCompletion: (isLiveAlbum: Bool) -> Void) -> () {
        
        T_ParseAlbumHelper.queryAlbumsOnParse(currentUser) {
            (albums:[T_Album]) -> Void in
            
            var finalAlbums:[T_Album] = []
            
            currentUser.liveAlbum = nil
            currentUser.albums.removeAll()
            
            print("----------\n\n")
            print("Number : \(albums.count) ")
            
            for album in albums {
                if (isAlbumInLive(album)) {
                    T_ParseAlbumHelper.pinLocalAlbum(album)
                    finalAlbums.append(album)
                }
            }
            
            if (finalAlbums.count > 0) {
                currentUser.liveAlbum = finalAlbums.first
                currentUser.albums.removeAll()
                currentUser.albums.appendContentsOf(finalAlbums)
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
        coverImage.value = T_Album.coverImageCache[self.cover.name]
        
        // if image is not downloaded yet, get it
        if (coverImage.value == nil) {
            // In background to not block the main thread
            cover.getDataInBackgroundWithBlock { (data: NSData?, error:NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data:data, scale: 1.0)!
                    // .value because it's an observable
                    self.coverImage.value = image
                    T_Album.coverImageCache[self.cover.name] = image
                }
                
            }
        }
    }
    
    func downloadCoverImageWithBlock(completionBlock: (cover: UIImage) -> Void) {
        // In background to not block the main thread
        cover.getDataInBackgroundWithBlock { (data: NSData?, error:NSError?) -> Void in
            if let data = data {
                let image = UIImage(data:data, scale: 1.0)!
                completionBlock(cover: image)
            }
        }
    }
}
