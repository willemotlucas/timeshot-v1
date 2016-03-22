//
//  T_FriendRequestTableViewCell.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 22/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_FriendRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var friendProfileImage: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
