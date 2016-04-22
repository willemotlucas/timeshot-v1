//
//  T_ParsePostHelper.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 15/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_ParsePostHelper {
    
    static func postsForCurrentAlbum(albumPhotos: T_Album, completionBlock: PFQueryArrayResultBlock) {
        
        
        // On va cherche tout nos post en fonction du nom de notre album
        // Et on veut recuperer aussi la personne qui a pris la photo
        // On les classe de la ordre ascendante ! Du debut a la fin
        let query = PFQuery(className: "Post")
        query.whereKey("toAlbum", equalTo: albumPhotos)
        query.whereKey("isDeleted", equalTo: false)
        query.includeKey("fromUser")
        query.orderByAscending("createdAt")
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
}