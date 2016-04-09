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
    
    static let liveAlbumPinnedLabel = "liveAlbum"
    
    static func getAlbumFromObjects(objects: [PFObject]?) -> T_Album? {
        if (objects?.count == 1) {
            return objects![0] as? T_Album
        }
        else {
            return nil
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
                print("Album found in pinned data")
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
    
    static func pinLocallyAlbum(album: T_Album) {
        
        T_Album.unpinAllObjectsInBackgroundWithName(liveAlbumPinnedLabel)
        album.pinInBackgroundWithName(liveAlbumPinnedLabel)
    }
}