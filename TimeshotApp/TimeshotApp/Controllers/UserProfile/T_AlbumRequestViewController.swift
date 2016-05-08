//
//  T_AlbumRequestViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 05/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond

protocol ModalViewControllerDelegate {
    func refreshTableView()
}

class T_AlbumRequestViewController: UIViewController {
    @IBOutlet weak var albumCover: UIImageView!
    
    var delegate: ModalViewControllerDelegate?

    var albumRequest: T_AlbumRequest?
    
    override func viewWillAppear(animated: Bool) {
        albumCover.image = albumRequest?.toAlbum!.coverImage.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if T_ParseUserHelper.getCurrentUser()?.liveAlbum != nil {
            print("live album found, cannot join another album!")
        } else {
            print("no album found ...")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func refuseButtonTapped(sender: UIButton) {
        T_ParseAlbumRequestHelper.rejectFriendRequest(self.albumRequest!) { (result: Bool, error: NSError?) in
            self.delegate?.refreshTableView()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func acceptButtonTapped(sender: UIButton) {
        if T_ParseUserHelper.getCurrentUser()?.liveAlbum != nil {
            T_AlertHelper.alertOK("Oups!", message: "You already have an album in progress...", viewController: self)
        } else {
            T_ParseAlbumRequestHelper.acceptAlbumRequest(self.albumRequest!) { (result: Bool, error: NSError?) in
                print("ready to return in profile view")
                self.delegate?.refreshTableView()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
