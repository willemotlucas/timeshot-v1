//
//  T_CameraViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 17/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import CameraManager
import Parse

class T_CameraViewController: UIViewController {
    
    static weak var instance:T_CameraViewController!
    
    let cameraManager = CameraManager()
    var image:UIImage?
    
    var isLiveAlbumExisting:Bool! = nil
    var albumTimer:NSTimer?
    
    private
    var isFlashActivated:Bool = false
    var isBackCameraActivated:Bool = true
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var buttonTakePicture: UIButton!
    var albumTitle: UILabel!
    var albumImage: UIImageView!
    
    @IBOutlet weak var buttonReturnCamera: UIButton!
    @IBOutlet weak var buttonFlash: UIButton!
    
    @IBOutlet weak var buttonAlbumVC: UIButton!
    
    @IBOutlet weak var buttonProfileVC: UIButton!
    
    @IBAction func actionTakePicture(sender: AnyObject) {
        
        cameraManager.capturePictureWithCompletition({
            (img, error) -> Void in
            self.image = img
            
            if (self.isLiveAlbumExisting == false)
            {
                self.performSegueWithIdentifier("segueCreateAlbum", sender: nil)
            }
            else
            {
                self.performSegueWithIdentifier("segueEditCameraImage", sender: nil)
            }
            
        })
    }
    
    @IBAction func switchCamera(sender: AnyObject) {
        
        if (isBackCameraActivated == true)
        {
            cameraManager.cameraDevice = .Front
            isBackCameraActivated = false
            isFlashActivated = false
        }
        else
        {
            cameraManager.cameraDevice = .Back
            isBackCameraActivated = true
        }
    }
    @IBAction func switchFlashStatus(sender: AnyObject) {
        
        if (cameraManager.hasFlash && !isFlashActivated)
        {
            cameraManager.changeFlashMode()
            isFlashActivated = true
        }
        else if (self.isFlashActivated == true)
        {
            cameraManager.changeFlashMode()
            isFlashActivated = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.cameraView.layer.zPosition = 0
        self.buttonTakePicture.layer.zPosition = 1
        self.buttonFlash.layer.zPosition = 1
        self.buttonReturnCamera.layer.zPosition = 1
        
        self.buttonAlbumVC.layer.zPosition = 10
        self.buttonProfileVC.layer.zPosition = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        T_CameraViewController.instance = self
        
        // Camera init
        cameraManager.addPreviewLayerToView(self.cameraView)
        cameraManager.cameraDevice = .Back
        cameraManager.cameraOutputMode = .StillImage
        cameraManager.cameraOutputQuality = .High
        cameraManager.flashMode = .Off
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.showAccessPermissionPopupAutomatically = true

        // If the application enter in background, we stop the timer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CameraViewController.stopAlbumTimer), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        // If the application is again active, we test once again if the album is existing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CameraViewController.retrieveExistingAlbum), name:UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func retrieveExistingAlbum() {
        T_Album.isALiveAlbumAlreadyExisting({ (isExisting:Bool) -> () in
            self.isLiveAlbumExisting = isExisting
            
            if (self.isLiveAlbumExisting == true) {
                if let currentUser = PFUser.currentUser() as? T_User {
                    if (currentUser.liveAlbum != nil) {
                        
                        if(self.albumTitle == nil) {
                            self.initLabelText()
                        }
                        
                        self.updateLabelText((currentUser.liveAlbum?.title)!)
                        
                        self.albumTimer = NSTimer.scheduledTimerWithTimeInterval(Double(T_Album.getRemainingDuration((currentUser.liveAlbum?.createdAt)!, duration: (currentUser.liveAlbum?.duration)!)), target: self, selector: #selector(T_CameraViewController.retrieveExistingAlbum), userInfo: nil, repeats: false)
                    }
                }
            }
            else {
                self.hideLabelText()
            }
        })
        
        if (self.isLiveAlbumExisting == nil)
        {
            self.isLiveAlbumExisting = false
        }
    }
    
    func stopAlbumTimer() {
        self.albumTimer?.invalidate()
    }
    
    func initLabelText() {
        self.albumTitle = UILabel(frame: CGRect(x: T_DesignHelper.screenSize.width/2, y: 16, width: 0, height: 24))
        self.albumImage = UIImageView(frame: CGRect(x: 0, y: 18, width: 24, height: 20))
        self.albumImage.image = UIImage(named: "AlbumName")
        
        self.albumTitle.layer.zPosition = 1
        self.albumTitle.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
        self.albumTitle.layer.cornerRadius = 12
        self.albumTitle.font = UIFont.systemFontOfSize(15)
        self.albumTitle.textColor = UIColor.whiteColor()
        self.albumTitle.layer.masksToBounds = true
        self.albumImage.layer.zPosition = 11
        
        self.view.addSubview(self.albumTitle)
        self.view.addSubview(self.albumImage)
    }
    
    func updateLabelText(text: String) {
        let finalText = "    \(text.trunc(30))"
        let textSize = finalText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15.0)])

        self.albumTitle.frame.size.width = 40 + textSize.width
        self.albumTitle.frame.origin = CGPoint(x: T_DesignHelper.screenSize.width/2 - self.albumTitle.frame.size.width/2, y: self.albumTitle.frame.origin.y)
        
        self.albumImage.contentMode = .ScaleAspectFit
        self.albumImage.frame.origin = CGPoint(x: T_DesignHelper.screenSize.width/2 + self.albumTitle.frame.size.width/2 - 33, y: self.albumImage.frame.origin.y)
        
        self.albumTitle.hidden = false
        self.albumImage.hidden = false
        
        self.albumTitle.text = finalText
    }
    
    func hideLabelText() {
        
        if (self.albumTitle != nil) {
            self.albumTitle.hidden = true
            self.albumImage.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (self.isLiveAlbumExisting == false)
        {
            let destinationVC = segue.destinationViewController as! T_CreateAlbumViewController
            destinationVC.image = self.image
            // To perform symetry / rotation if needed when computing the image for filters
            destinationVC.isFrontCamera = !self.isBackCameraActivated
        }
        else
        {
            let destinationVC = segue.destinationViewController as! T_EditCameraImageViewController
            destinationVC.image = self.image
            // To perform symetry / rotation if needed when computing the image for filters
            destinationVC.isFrontCamera = !self.isBackCameraActivated
        }
    }
    
    
    //MARK: - Systems methods
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
