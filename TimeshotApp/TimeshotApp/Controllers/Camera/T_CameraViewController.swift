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
import MBProgressHUD

class T_CameraViewController: UIViewController {
    
    //MARK: Static properties
    static weak var instance:T_CameraViewController!
    
    //MARK: Properties
    let cameraManager = CameraManager()
    var image:UIImage?
    
    var progressHUD:MBProgressHUD?
    
    var isLiveAlbumExisting:Bool! = nil
    var albumTimer:NSTimer?
    var albumTitle: UILabel!
    var albumImage: UIImageView!
    
    private
    var isFlashActivated:Bool = false
    var isBackCameraActivated:Bool = true
    
    //MARK: - Outlets properties
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var buttonTakePicture: UIButton!
    @IBOutlet weak var buttonReturnCamera: UIButton!
    @IBOutlet weak var buttonFlash: UIButton!
    @IBOutlet weak var buttonAlbumVC: UIButton!
    @IBOutlet weak var buttonProfileVC: UIButton!
    
    
    //MARK: - Outlets Methods
    @IBAction func actionTakePicture(sender: AnyObject) {
        
        cameraManager.capturePictureWithCompletition({
            (img, error) -> Void in
            self.image = img
            
            UIView.setAnimationsEnabled(false)
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
            buttonFlash.setImage(UIImage(named: "CameraNoFlash"), forState: .Normal)
            cameraManager.changeFlashMode()
            isFlashActivated = true
        }
        else if (self.isFlashActivated == true)
        {
            buttonFlash.setImage(UIImage(named: "CameraFlash"), forState: .Normal)
            cameraManager.changeFlashMode()
            isFlashActivated = false
        }
    }
    
    @IBAction func actionButtonAlbum(sender: AnyObject) {
        
        T_HomePageViewController.showAlbumViewController()
    }
    @IBAction func actionButtonProfile(sender: AnyObject) {
        
        T_HomePageViewController.showProfileViewController()

    }
    //MARK: - Systems methods
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cameraManager.cameraOutputQuality = .Medium
        cameraManager.flashMode = .Off
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.showAccessPermissionPopupAutomatically = true

        // If the application enter in background, we stop the timer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CameraViewController.stopAlbumTimer), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        // If the application is again active, we test once again if the album is existing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CameraViewController.manageAlbumProcessing), name:UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (self.isLiveAlbumExisting == false) {
            let destinationVC = segue.destinationViewController as! T_CreateAlbumViewController
            destinationVC.image = self.image
            // To perform symetry / rotation if needed when computing the image for filters
            destinationVC.isFrontCamera = !self.isBackCameraActivated
        }
        else {
            let destinationVC = segue.destinationViewController as! T_EditCameraImageViewController
            destinationVC.image = self.image
            // To perform symetry / rotation if needed when computing the image for filters
            destinationVC.isFrontCamera = !self.isBackCameraActivated
            destinationVC.post = T_Post.createPost()
        }
    }
    
    //MARK: - Methods
    func manageAlbumProcessing() {
        guard let currentUser = PFUser.currentUser() as? T_User else { return }
        
        self.isLiveAlbumExisting = false
        self.hideLabelText()
        
        T_Album.manageAlbumProcessing(currentUser) {
            (isLiveAlbum: Bool) -> Void in
            
            self.isLiveAlbumExisting = isLiveAlbum
            
            if (isLiveAlbum) {
                
                guard let album = currentUser.liveAlbum else { return  }

                self.updateLabelText(album.title)
                
                self.albumTimer = NSTimer.scheduledTimerWithTimeInterval(Double(T_Album.getRemainingDuration((currentUser.liveAlbum?.createdAt)!, duration: (currentUser.liveAlbum?.duration)!)), target: self, selector: #selector(T_CameraViewController.manageAlbumProcessing), userInfo: nil, repeats: false)
            }
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
        
        if(self.albumTitle == nil) {
            self.initLabelText()
        }

        let finalText = "   \(text.trunc(30))"
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
    
    func freezeUI(text: String) {
        
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD?.labelText = text
        progressHUD?.mode = .Indeterminate
        
        buttonTakePicture.hidden = true
        buttonReturnCamera.hidden = true
        buttonFlash.hidden = true
    }
    
    func unfreezeUI() {
        progressHUD?.hide(true)
        
        buttonTakePicture.hidden = false
        buttonReturnCamera.hidden = false
        buttonFlash.hidden = false

    }
}
