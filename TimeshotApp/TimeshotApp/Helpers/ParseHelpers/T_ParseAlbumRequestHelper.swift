//
//  T_ParseAlbumRequestHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 30/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

/*
 * List of the differents possible status of a friend request
 */
enum AlbumRequestStatus {
    case Pending, Accepted, Rejected
}


class T_ParseAlbumRequestHelper {
    // MARK: Parse columns name
    static let ParseAlbumRequestClass = "AlbumRequest"
    static let ParseAlbumRequestFromUser = "fromUser"
    static let ParseAlbumRequestToUser = "toUser"
    static let ParseAlbumRequestStatus = "status"
    static let ParseAlbumRequestToAlbum = "toAlbum"
    
    // MARK: Methods
    
    /*
     * This methods convert a status from enum to a string
     *
     * Params:
     * - @status : the status to convert
     * Return:
     * - String corresponding to the status
     */
    static func albumRequestStatus(status: AlbumRequestStatus) -> String{
        switch(status){
        case .Accepted: return "Accepted"
        case .Pending: return "Pending"
        case .Rejected: return "Rejected"
        }
    }
    
    // MARK: Parse methods
    
    /*
     * Retrieve all the pending album requests from the current user.
     *
     * Params:
     * - @completionBlock : the methods executed asynchroneously when all the pending requests have been retrieved
     */
    static func getPendingAlbumRequestToCurrentUser(completionBlock: PFQueryArrayResultBlock?) {
        let pendingAlbumRequest = PFQuery(className: ParseAlbumRequestClass)
        pendingAlbumRequest.whereKey(ParseAlbumRequestStatus, equalTo: albumRequestStatus(.Pending))
        pendingAlbumRequest.whereKey(ParseAlbumRequestToUser, equalTo: PFUser.currentUser()!)
        pendingAlbumRequest.includeKey(ParseAlbumRequestFromUser)
        pendingAlbumRequest.includeKey(ParseAlbumRequestToAlbum)
        
        pendingAlbumRequest.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    /*
     * Retrieve all the pending album requests from the current album.
     *
     * Params:
     * - @completionBlock : the methods executed asynchroneously when all the pending requests have been retrieved
     */
    static func getPendingAlbumRequestToCurrentAlbum(toAlbum: T_Album, completionBlock: PFQueryArrayResultBlock?) {
        let pendingAlbumRequest = PFQuery(className: ParseAlbumRequestClass)
        pendingAlbumRequest.whereKey(ParseAlbumRequestStatus, equalTo: albumRequestStatus(.Pending))
        pendingAlbumRequest.whereKey(ParseAlbumRequestToAlbum, equalTo: toAlbum)
        pendingAlbumRequest.includeKey(ParseAlbumRequestFromUser)
        
        pendingAlbumRequest.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    
    /*
     * Send an album request to a user
     *
     * Params:
     * - @toUser : the user we have to send the friend request
     */
    static func sendFriendRequest(toUser: T_User, toAlbum: T_Album){
        let albumRequest = T_AlbumRequest(toUser: toUser, toAlbum: toAlbum)
        albumRequest.saveInBackgroundWithBlock { (result: Bool, error: NSError?) in

        }
    }
    
    /*
     * Accept an album request
     *
     * Params:
     * - @friendRequest : the album request to change in Accepted status
     * - @completionBlock : the methods which will be executed after editing the status
     */
    static func acceptAlbumRequest(albumRequest: T_AlbumRequest, completionBlock: PFBooleanResultBlock){
        albumRequest.status = albumRequestStatus(.Accepted)
        
        let currentUser = T_ParseUserHelper.getCurrentUser()!
        let album = albumRequest.toAlbum

        let query = PFQuery(className: T_ParseAlbumHelper.ParseAlbumClass)
        query.whereKey("objectId", equalTo: (album?.objectId)!)
        query.includeKey("attendees")
        
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
            let album = result?.first as! T_Album
            album.attendees.append(currentUser)
            album.saveInBackgroundWithBlock({ (result: Bool, error: NSError?) in
                albumRequest.saveInBackgroundWithBlock(completionBlock)
            })
        }
    }
    
    /*
     * Reject a friend request
     *
     * Params:
     * - @friendRequest : the album request to change in Rejected status
     * - @completionBlock : the methods which will be executed after editing the status
     */
    static func rejectFriendRequest(albumRequest: T_AlbumRequest, completionBlock: PFBooleanResultBlock){
        albumRequest.status = albumRequestStatus(.Rejected)
        albumRequest.saveInBackgroundWithBlock(completionBlock)
    }
    
    static func sendAlbumRequestNotification(userInvited: T_User){
        let pushQuery = PFInstallation.query()!
        pushQuery.whereKey("user", equalTo: userInvited) //friend is a PFUser object
        
        let data = ["alert" : "\(T_ParseUserHelper.getCurrentUser()!.username!) invited you to join his album", "badge" : "Increment"]
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(data)
        push.sendPushInBackground()
    }
}