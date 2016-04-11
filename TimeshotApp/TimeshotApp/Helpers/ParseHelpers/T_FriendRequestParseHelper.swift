//
//  T_FriendRequestParseHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 08/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

/*
 * List of the differents possible status of a friend request
 */
enum FriendRequestStatus {
    case Pending, Accepted, Rejected
}

/*
 * Class T_FriendRequestParseHelper
 * Allows us to make request to Parse server to retrieve and store T_FriendRequest object.
 */
class T_FriendRequestParseHelper {
    // MARK: Parse columns name
    static let ParseFriendRequestClass = "FriendRequest"
    static let ParseFriendRequestFromUser = "fromUser"
    static let ParseFriendRequestToUser = "toUser"
    static let ParseFriendRequestStatus = "status"
    
    // MARK: Properties
    static var friends: [T_User] = []
    
    // MARK: Methods
    
    /*
     * This methods convert a status from enum to a string
     *
     * Params:
     * - @status : the status to convert
     * Return:
     * - String corresponding to the status
     */
    static func friendRequestStatus(status: FriendRequestStatus) -> String{
        switch(status){
        case .Accepted: return "Accepted"
        case .Pending: return "Pending"
        case .Rejected: return "Rejected"
        }
    }
    
    /*
     * Retrieve all the pending friend request from the current user
     *
     * Params:
     * - @completionBlock : the methods executed asynchroneously when all the pending requests have been retrieved
    */
    static func getPendingFriendRequest(completionBlock: PFQueryArrayResultBlock?){
        let pendingFriendRequest = PFQuery(className: ParseFriendRequestClass)
        pendingFriendRequest.whereKey(ParseFriendRequestStatus, equalTo: friendRequestStatus(.Pending))
        pendingFriendRequest.whereKey(ParseFriendRequestToUser, equalTo: PFUser.currentUser()!)
        pendingFriendRequest.includeKey(ParseFriendRequestFromUser)
        pendingFriendRequest.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    /*
     * Retrieve all the accepted friend request from the current user
     * Warning: it don't give the list of the friends. To retrieve the list of friends, please use getFriendFromAcceptedRequests
     * with the result of getAcceptedFriendRequest
     *
     * Params:
     * - @completionBlock : the methods executed asynchroneously when all the pending requests have been retrieved
     */
    static func getAcceptedFriendRequest(completionBlock: PFQueryArrayResultBlock){
        // Query to retrieve all the all friend request created by the current user
        let acceptedFriendRequestFromMe = PFQuery(className: ParseFriendRequestClass)
        acceptedFriendRequestFromMe.whereKey(ParseFriendRequestStatus, equalTo: friendRequestStatus(.Accepted))
        acceptedFriendRequestFromMe.whereKey(ParseFriendRequestFromUser, equalTo: PFUser.currentUser()!)
        
        // Query to retrieve all the friend request received bu the current user
        let acceptedFriendRequestToMe = PFQuery(className: ParseFriendRequestClass)
        acceptedFriendRequestToMe.whereKey(ParseFriendRequestStatus, equalTo: friendRequestStatus(.Accepted))
        acceptedFriendRequestToMe.whereKey(ParseFriendRequestToUser, equalTo: PFUser.currentUser()!)

        // Build a query with the 2 previous queries
        let acceptedFriendRequest = PFQuery.orQueryWithSubqueries([acceptedFriendRequestFromMe, acceptedFriendRequestToMe])
        
        // Include users to retrieve their data
        acceptedFriendRequest.includeKey(ParseFriendRequestFromUser)
        acceptedFriendRequest.includeKey(ParseFriendRequestToUser)

        acceptedFriendRequest.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    /*
     * Retrieve all the friends from the current user
     *
     * Params:
     * - @acceptedFriendRequests : an array of accepted friend request
     * Return:
     * - [T_User] an array of T_User containing the friends of the current user
     */
    static func getFriendsFromAcceptedRequests(acceptedFriendRequests: [T_FriendRequest]) -> [T_User] {
        var friends: [T_User] = []
        // We iterate through the array to build the list of friends
        for request in acceptedFriendRequests {
            if request.fromUser?.objectId == PFUser.currentUser()!.objectId {
                // If the current user created the friend request, then we keep toUser
                friends.append(request.toUser as! T_User)
            } else {
                // Otherwise, the current user received the friend request, so we keep fromUser
                friends.append(request.fromUser as! T_User)
            }
        }
        
        return friends
    }
    
    /*
     * Send a friend request to a user
     *
     * Params:
     * - @toUser : the user we have to send the friend request
     */
    static func sendFriendRequest(toUser: T_User){
        let friendRequest = T_FriendRequest(toUser: toUser)
        friendRequest.saveInBackgroundWithBlock(nil)
    }
    
    /*
     * Accept a friend request
     *
     * Params:
     * - @friendRequest : the friend request to change in Accepted status
     * - @completionBlock : the methods which will be executed after editing the status
     */
    static func acceptFriendRequest(friendRequest: T_FriendRequest, completionBlock: PFBooleanResultBlock){
        friendRequest.status = friendRequestStatus(.Accepted)
        friendRequest.saveInBackgroundWithBlock(completionBlock)
    }
    
    /*
     * Reject a friend request
     *
     * Params:
     * - @friendRequest : the friend request to change in Rejected status
     * - @completionBlock : the methods which will be executed after editing the status
     */
    static func rejectFriendRequest(friendRequest: T_FriendRequest, completionBlock: PFBooleanResultBlock){
        friendRequest.status = friendRequestStatus(.Rejected)
        friendRequest.saveInBackgroundWithBlock(completionBlock)
    }
    
}
