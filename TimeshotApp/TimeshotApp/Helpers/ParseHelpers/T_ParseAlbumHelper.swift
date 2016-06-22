//
//  T_ParseAlbumHelper.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 09/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_ParseAlbumHelper {
    static let ParseAlbumClass = "Album"
    static let ParseAttendeesClass = "attendees"
    
    static let liveAlbumPinnedLabel = "liveAlbum"
    
    static func getAlbumFromObjects(objects: [PFObject]?) -> T_Album? {
        if (objects?.count == 1) {
            return objects![0] as? T_Album
        }
        else {
            return nil
        }
    }
    
    static func getAlbumsFromObjects(objects: [PFObject]?) -> [T_Album] {
        var album:[T_Album] = []
        if (objects?.count > 0) {
            for o in objects! {
                album.append(o as! T_Album)
            }
            return album
        }
        else {
            return []
        }
    }
    
    static func queryAlbumPinned(withCompletion completion: (liveAlbum: T_Album?) -> ()) {
        
        let query2 = T_Album.query()
        query2!.fromLocalDatastore()
        query2!.fromPinWithName(liveAlbumPinnedLabel)
        query2!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if (error == nil)
            {
                completion(liveAlbum: getAlbumFromObjects(objects))
                return
            }
            else {
                print("error to find Album locally in background")
                completion(liveAlbum: nil)
                return
            }
        }
    }
    
    // MultiAlbum
    static func queryAlbumsPinned(withCompletion completion: (liveAlbum: [T_Album]) -> ()) {
        
        let query2 = T_Album.query()
        query2!.fromLocalDatastore()
        query2!.fromPinWithName(liveAlbumPinnedLabel)
        query2!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if (error == nil)
            {
                let albums = getAlbumsFromObjects(objects)
                var finalAlbums:[T_Album] = []
                
                for a in albums {
                    if (T_Album.isAlbumInLive(a)) {
                        finalAlbums.append(a)
                    }
                }
                
                completion(liveAlbum: finalAlbums)
                return
            }
            else {
                print("error to find Album locally in background")
                completion(liveAlbum: [])
                return
            }
        }
    }
    
    
    static func queryAllAlbumsOnParse(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
        
        let query = PFQuery(className: "Album")
        //let query = T_Album.query()
        
        query.whereKey("attendees", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.includeKey("attendees")
        
        // Range of the album that we want
        query.skip =  range.startIndex
        query.limit = range.endIndex -  range.startIndex
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func queryLastAlbumOnParse(currentUser: T_User, withCompetion completion: (liveAlbum: T_Album?) -> ()) {
        
        let query = PFQuery(className: "Album")
        query.whereKey("attendees", equalTo: currentUser)
        query.orderByDescending("createdAt")
        query.limit = 1
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error == nil) {
                completion(liveAlbum: getAlbumFromObjects(objects))
                return
            }
            else {
                completion(liveAlbum: nil)
                return
            }
        }
        
        completion(liveAlbum: nil)
    }
    
    
    static func queryAlbumsOnParse(currentUser: T_User, withCompetion completion: (albums: [T_Album]) -> ()) {
        
        let query = PFQuery(className: "Album")
        query.whereKey("attendees", equalTo: currentUser)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            
            if (error == nil) {
                completion(albums: getAlbumsFromObjects(objects))
                return
            }
            else {
                completion(albums: [])
                return
            }
        }
        
        completion(albums: [])
    }
    
    
    static func pinLocallyAlbum(album: T_Album) {
        
        T_Album.unpinAllObjectsInBackgroundWithName(liveAlbumPinnedLabel)
        album.pinInBackgroundWithName(liveAlbumPinnedLabel)
    }
    
    static func unpinLocalAlbum() {
        T_Album.unpinAllObjectsInBackgroundWithName(liveAlbumPinnedLabel)
    }
    
    static func pinLocalAlbum(album: T_Album) {
        album.pinInBackgroundWithName(liveAlbumPinnedLabel)
    }
    
    
}