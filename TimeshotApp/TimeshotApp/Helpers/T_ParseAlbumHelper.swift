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
        
    static func getAlbumFromObjects(objects: [PFObject]?) -> T_Album? {
        if (objects?.count == 1) {
            return objects![0] as? T_Album
        }
        else {
            return nil
        }
    }


    static func queryAlbumPinned(withCompletion: (liveAlbum: T_Album?) -> ()) {
     
        let query2 = T_Album.query()
        query2!.fromLocalDatastore()
        query2!.fromPinWithName("liveAlbum")
        query2!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if (error == nil)
            {
                withCompletion(liveAlbum: getAlbumFromObjects(objects))
            }
            else {
                print("error to find Album locally in background")
                withCompletion(liveAlbum: nil)
            }
        }
    }
}