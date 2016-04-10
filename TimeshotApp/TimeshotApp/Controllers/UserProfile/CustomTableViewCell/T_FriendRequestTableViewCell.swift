//
//  T_FriendRequestTableViewCell.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 22/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse

protocol TableViewUpdater {
    func updatePendingRequestsAfterAccepting(request: T_FriendRequest)
    func updatePendingRequestsAfterRejecting(request: T_FriendRequest)
}

class T_FriendRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var friendProfileImage: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    var delegate: TableViewUpdater?
    var friendRequest: T_FriendRequest!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func acceptFriendRequestTapped(sender: UIButton) {
        T_FriendRequestParseHelper.acceptFriendRequest(self.friendRequest) { (result: Bool, error: NSError?) in
            let fromUser = self.friendRequest.fromUser! as! T_User
            
            //Add the new friendship for the current user
            let friendshipCurrentUser = PFUser.currentUser()!.relationForKey("friendShip")
            friendshipCurrentUser.addObject(fromUser)
            PFUser.currentUser()!.saveInBackgroundWithBlock(nil)
            
            //Add the new friendship for the other user
            let friendshipOtherUser = fromUser.relationForKey("friendShip")
            let currentUser = PFUser.currentUser()! as! T_User
            friendshipOtherUser.addObject(currentUser)
            fromUser.saveInBackgroundWithBlock(nil)
            
            self.updatePendingRequestsAfterAccepting()
        }
    }
    
    @IBAction func rejectFriendRequestTapped(sender: UIButton) {
        T_FriendRequestParseHelper.rejectFriendRequest(self.friendRequest) { (result: Bool, error: NSError?) in
            self.updatePendingRequestsAfterRejecting()
        }
    }
    
    func updatePendingRequestsAfterAccepting() {
        delegate?.updatePendingRequestsAfterAccepting(self.friendRequest)
    }
    
    func updatePendingRequestsAfterRejecting() {
        delegate?.updatePendingRequestsAfterRejecting(self.friendRequest)
    }
}
