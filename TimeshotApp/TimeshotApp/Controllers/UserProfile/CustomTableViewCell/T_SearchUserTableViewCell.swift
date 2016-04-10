//
//  T_UserTableViewCell.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 09/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

protocol AddNewFriends {
    func sendUserSelected(userSelected: T_User)
}

class T_SearchUserTableViewCell: UITableViewCell {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userFirstAndLastNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addUserButton: UIButton!
    
    var delegate: AddNewFriends?
    var user: T_User!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addFriendButtonTapped(sender: UIButton) {
        print("button clicked")
        delegate?.sendUserSelected(self.user)
    }
}
