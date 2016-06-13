//
//  T_NotificationsTableViewCell.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 30/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond

protocol AlbumRequestsUpdater {
    func updateAlbumRequestsTableView(request: T_AlbumRequest)
    func showHUD()
    func hideHUD()
    func displayAlert(message: String)
}

class T_AlbumRequestNotificationsTableViewCell: UITableViewCell {
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

    /*@IBAction func acceptAlbumRequestButtonTapped(sender: UIButton) {
        if T_CameraViewController.instance.isLiveAlbumExisting == true {
            self.delegate?.displayAlert("You already have an album in progress...")
        } else {
            if Reachability.isConnectedToNetwork() {
                self.delegate?.showHUD()
                T_ParseAlbumRequestHelper.acceptAlbumRequest(self.albumRequest!) { (result: Bool, error: NSError?) in
                    T_CameraViewController.instance.manageAlbumProcessing()
                    self.delegate?.hideHUD()
                    self.delegate?.updateAlbumRequestsTableView(self.albumRequest!)
                }
            } else {
                self.delegate?.displayAlert("No internet connection... Please try again later")
            }
        }
    }
    
    @IBAction func refuseAlbumRequestButtonTapped(sender: UIButton) {
        T_ParseAlbumRequestHelper.rejectFriendRequest(self.albumRequest!) { (result: Bool, error: NSError?) in
            self.delegate?.updateAlbumRequestsTableView(self.albumRequest!)
        }
    }*/
}
