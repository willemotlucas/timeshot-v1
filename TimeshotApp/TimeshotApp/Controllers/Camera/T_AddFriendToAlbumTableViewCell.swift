//
//  addFriendToAlbumTableViewCell.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 28/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond

class T_AddFriendToAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var checkbox: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    weak var user: T_User? {
        
        didSet {
            if let user = user {
                user.image.bindTo(self.picture.bnd_image)
                self.setProfilPicture()
            }
        }
    }
    
    func setProfilPicture() {
        self.picture.layer.cornerRadius = 20
        self.picture.layer.masksToBounds = true
        self.picture.contentMode = .ScaleAspectFill
    }
    
    deinit
    {
    }
}
