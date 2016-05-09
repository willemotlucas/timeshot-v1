//
//  T_AddToAlbumTableViewCell.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 08/05/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AddToAlbumTableViewCell: UITableViewCell {

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
