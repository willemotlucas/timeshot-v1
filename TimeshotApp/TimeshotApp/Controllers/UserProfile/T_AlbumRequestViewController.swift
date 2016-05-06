//
//  T_AlbumRequestViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 05/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond

class T_AlbumRequestViewController: UIViewController {
    @IBOutlet weak var albumCover: UIImageView!
    
    var albumRequest: T_AlbumRequest?
    
    override func viewWillAppear(animated: Bool) {
        albumCover.image = albumRequest?.toAlbum!.coverImage.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
