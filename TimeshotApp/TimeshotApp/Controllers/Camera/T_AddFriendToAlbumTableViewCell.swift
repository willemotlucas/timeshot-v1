//
//  addFriendToAlbumTableViewCell.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 28/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AddFriendToAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var checkbox: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    func setProfilPicture(picture: UIImage) {
        self.picture.image = picture
        self.picture.layer.cornerRadius = 20
        self.picture.layer.masksToBounds = true
        self.picture.contentMode = .ScaleAspectFill
    }
    
    deinit
    {
    }
}
