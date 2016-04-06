//
//  T_AddFriendAlbumLiveTableViewCell.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 31/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AddFriendAlbumLiveTableViewCell: UITableViewCell {

    @IBOutlet weak var friendProfileImage: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendAddButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
