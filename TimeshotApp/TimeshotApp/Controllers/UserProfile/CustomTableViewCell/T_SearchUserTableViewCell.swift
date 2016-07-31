//
//  T_UserTableViewCell.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 09/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond

protocol AddNewFriends {
    func sendUserSelected(userSelected: T_User)
}

class T_SearchUserTableViewCell: UITableViewCell {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userFirstAndLastNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addUserButton: UIButton!
    
    var delegate: AddNewFriends?
    var user: T_User?{
        didSet{
            friendDisposable?.dispose()
            
            if let user = user {
                friendDisposable = user.image.bindTo(self.userProfileImageView.bnd_image)
                T_DesignHelper.makeRoundedImageView(self.userProfileImageView)
                if let _ = user.username {
                    self.usernameLabel.text = "@" + user.username!
                }
                
                if let _ = user.firstName {
                    if let _ = user.lastName {
                        self.userFirstAndLastNameLabel.text = user.firstName! + " " + user.lastName!
                    }
                }
            }
        }
    }
    
    var friendDisposable: DisposableType?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addFriendButtonTapped(sender: UIButton) {
        // Call the delegate only if the user is not alreayd a friend
        if sender.enabled == true {
            self.addUserButton.setImage(UIImage(named: "check-pending"), forState: .Disabled)
            self.addUserButton.enabled = false
            delegate?.sendUserSelected(self.user!)
        }
    }
}
