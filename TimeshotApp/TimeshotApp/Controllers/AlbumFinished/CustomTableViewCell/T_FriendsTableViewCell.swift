//
//  T_FriendsTableViewCell.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 20/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond

class T_FriendsTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user : T_User? {
        didSet {
            if let user = user {
                user.image.bindTo(userImageView.bnd_image)
            }
        }
    }
    
    // MARK: Init
    func initWithUser(user: T_User) {
        var newName = ""
        if let _ = user.firstName {
            newName += user.firstName! + " "
        }
        
        if let _ = user.lastName {
            newName += user.lastName!
        }
        
        if !newName.isEmpty {
            nameLabel.text = newName
        }
        
        if let _ = user.username {
            usernameLabel.text = "@"+user.username!
        }
        
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        
        self.selectionStyle = .None
        
        
    }
    

    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

