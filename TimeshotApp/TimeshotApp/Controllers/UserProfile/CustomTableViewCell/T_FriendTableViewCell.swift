//
//  T_FriendTableViewCell.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 22/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond

class T_FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var friendProfileImage: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    var friend: T_User? {
        didSet{
            friendDisposable?.dispose()
            
            if let user = friend {
                friendDisposable = user.image.bindTo(friendProfileImage.bnd_image)
                T_DesignHelper.makeRoundedImageView(self.friendProfileImage)
                self.friendNameLabel.text = user.firstName! + " " + user.lastName!
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

}
