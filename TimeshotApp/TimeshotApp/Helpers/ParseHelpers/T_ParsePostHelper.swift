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
    
    static let ParsePostClass = "Post"
    static let ParsePostToAlbum = "toAlbum"
    static let ParsePostObjectId = "ObjectId"
    static let ParsePostFromUser = "fromUser"
    static let ParsePostIsDeleted = "isDeleted"
    
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
    
    static func getAllPostNotVoted(user : T_User, _ album : T_Album, _ completionBlock : ([T_Post]? -> Void)?) {
        let voteQ = T_Vote.query()!
        voteQ.whereKey(T_ParseVoteHelper.ParseVoteFromUser, notEqualTo: user)
        voteQ.findObjectsInBackgroundWithBlock{array , error -> Void in
            if error == nil && !(array?.isEmpty)! {
                let votes = array!.map{n -> String in (n[T_ParseVoteHelper.ParseVoteToPost])!.objectId!!}
                let postQuery = T_Post.query()!
                postQuery.whereKey(ParsePostToAlbum, equalTo: album)
                postQuery.whereKey(ParsePostObjectId, notContainedIn: votes)
                postQuery.findObjectsInBackgroundWithBlock{objs , error -> Void in
                    if error == nil && !(objs?.isEmpty)! {
                        completionBlock?(objs as! [T_Post]?)
                    }
                }
            }
            
        }
    }

}
