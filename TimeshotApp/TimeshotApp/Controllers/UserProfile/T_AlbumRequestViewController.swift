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
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var delegate: ModalViewControllerDelegate?
    
    var albumRequest: T_AlbumRequest?
    
    var album: T_Album? {
        didSet {
            if let album = album {
                album.downloadCoverImageWithBlock({ (cover) in
                    self.activityIndicatorView.stopAnimating()
                    self.albumCover.image = cover
                })
            }
        }
    }
    
    //var albumRequestDisposable: DisposableType?
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorUIView(self.controlView)
        UIColor.clearColor().colorWithAlphaComponent(0.7)
        activityIndicatorView.startAnimating()
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
        if T_CameraViewController.instance.isLiveAlbumExisting == true {
            T_AlertHelper.alertOK("Oups!", message: "You already have an album in progress...", viewController: self)
        } else {
            T_ParseAlbumRequestHelper.acceptAlbumRequest(self.albumRequest!) { (result: Bool, error: NSError?) in
                T_CameraViewController.instance.manageAlbumProcessing()
                self.delegate?.refreshTableView()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
