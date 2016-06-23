//
//  T_ParseVoteHelper.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 09/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_ParseVoteHelper {
    
    static let ParseVoteClass = "Vote"
    static let ParseVoteFromUser = "fromUser"
    static let ParseVoteToPost = "toPost"
    static let ParseVoteIsLiked = "isLiked"
    
    
    //TODO Delete
    static func getLiveAlbum(){
        let albumQuery = T_Album.query()!
        albumQuery.whereKey("attendees", equalTo: T_User.currentUser()!)
        let alqu = T_Album.query()!
        alqu.whereKey("createdBy", equalTo: T_User.currentUser()!)
        let q = PFQuery.orQueryWithSubqueries([albumQuery,alqu])
        q.findObjectsInBackgroundWithBlock{ arrayObject, error -> Void in
            for obj in arrayObject! {
                let album = obj as! T_Album
                print(album.title)
                if T_Album.isAlbumInLive(album) {
                    T_ParsePostHelper.getAllPostNotVoted(T_User.currentUser()!, album, nil)
                }
            }
        }
    }
    
    static func liked(post : T_Post, user : T_User) {
        post.hasVoted.append(user)
        post.voteNumber += 1
        post.saveInBackgroundWithBlock(nil)
    }
    
    static func disliked(post : T_Post, user : T_User) {
        post.hasVoted.append(user)
        post.saveInBackgroundWithBlock(nil)
    }
    
    
}