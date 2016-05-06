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
                self.usernameLabel.text = "@" + user.username!
                self.userFirstAndLastNameLabel.text = user.firstName! + " " + user.lastName!
            }
        }
    }
    
    var friendDisposable: DisposableType?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addFriendButtonTapped(sender: UIButton) {
        // Call the delegate only if the user is not alreayd a friend
        if sender.selected == false {
            sender.selected = true
            delegate?.sendUserSelected(self.user!)
        }
    }
}
