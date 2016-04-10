//
//  T_FriendRequestParseHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 08/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

enum FriendRequestStatus {
    case Pending, Accepted, Rejected
}

class T_FriendRequestParseHelper {
    static let ParseFriendRequestClass = "FriendRequest"
    static let ParseFriendRequestFromUser = "fromUser"
    static let ParseFriendRequestToUser = "toUser"
    static let ParseFriendRequestStatus = "status"
    
    static var friends: [T_User] = []
    
    static func friendRequestStatus(status: FriendRequestStatus) -> String{
        switch(status){
        case .Accepted: return "Accepted"
        case .Pending: return "Pending"
        case .Rejected: return "Rejected"
        }
    }
    
    static func getPendingFriendRequest(completionBlock: PFQueryArrayResultBlock?){
        let pendingFriendRequest = PFQuery(className: ParseFriendRequestClass)
        pendingFriendRequest.whereKey(ParseFriendRequestStatus, equalTo: friendRequestStatus(.Pending))
        pendingFriendRequest.whereKey(ParseFriendRequestToUser, equalTo: PFUser.currentUser()!)
        pendingFriendRequest.includeKey(ParseFriendRequestFromUser)
        pendingFriendRequest.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func getAcceptedFriendRequest(completionBlock: PFQueryArrayResultBlock){
        let acceptedFriendRequestFromMe = PFQuery(className: ParseFriendRequestClass)
        acceptedFriendRequestFromMe.whereKey(ParseFriendRequestStatus, equalTo: friendRequestStatus(.Accepted))
        acceptedFriendRequestFromMe.whereKey(ParseFriendRequestFromUser, equalTo: PFUser.currentUser()!)
        
        let acceptedFriendRequestToMe = PFQuery(className: ParseFriendRequestClass)
        acceptedFriendRequestToMe.whereKey(ParseFriendRequestStatus, equalTo: friendRequestStatus(.Accepted))
        acceptedFriendRequestToMe.whereKey(ParseFriendRequestToUser, equalTo: PFUser.currentUser()!)

        let acceptedFriendRequest = PFQuery.orQueryWithSubqueries([acceptedFriendRequestFromMe, acceptedFriendRequestToMe])
        acceptedFriendRequest.includeKey(ParseFriendRequestFromUser)
        acceptedFriendRequest.includeKey(ParseFriendRequestToUser)

        acceptedFriendRequest.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func getFriendsFromAcceptedRequests(acceptedFriendRequests: [T_FriendRequest]) -> [T_User] {
        var friends: [T_User] = []
        for request in acceptedFriendRequests {
            if request.fromUser?.objectId == PFUser.currentUser()!.objectId {
                friends.append(request.toUser as! T_User)
            } else {
                friends.append(request.fromUser as! T_User)
            }
        }
        
        return friends
    }
    
    static func sendFriendRequest(toUser: T_User){
        let friendRequest = T_FriendRequest(toUser: toUser)
        friendRequest.saveInBackgroundWithBlock(nil)
    }
    
    static func acceptFriendRequest(friendRequest: T_FriendRequest, completionBlock: PFBooleanResultBlock){
        friendRequest.status = friendRequestStatus(.Accepted)
        friendRequest.saveInBackgroundWithBlock(completionBlock)
    }
    
    static func rejectFriendRequest(friendRequest: T_FriendRequest, completionBlock: PFBooleanResultBlock){
        friendRequest.status = friendRequestStatus(.Rejected)
        friendRequest.saveInBackgroundWithBlock(completionBlock)
    }
    
}

extension PFObject {
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
}
