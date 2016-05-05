//
//  T_NotificationsTableViewCell.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 30/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond

class T_NotificationsTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var notificationHelpTextLabel: UILabel!
    
    var albumRequest: T_AlbumRequest?
    var friend: T_User? {
        didSet{
            friendDisposable?.dispose()
            
            if let user = friend {
                friendDisposable = user.image.bindTo(profileImageView.bnd_image)
                T_DesignHelper.makeRoundedImageView(self.profileImageView)
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
