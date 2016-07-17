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
    
    var isLiveAlbumExisting:Bool! = false
    var albumTimer:NSTimer?
    var newtorkManager = T_NetworkManager.sharedInstance
    var networkStatus = T_NetworkStatus.sharedInstance
    let tapOnNetworkStatus = UITapGestureRecognizer()
    
    //let multiAlbumStatus = T_MultiAlbumStatus.sharedInstance
    var modalView = T_ModalView(frame: CGRect(origin: CGPoint(x: 0, y: -T_DesignHelper.screenSize.height), size: T_DesignHelper.screenSize))
    var quitButton = UIButton(frame: CGRect(x: 10, y: 10, width: 34, height: 34))
    
    //Key words for auto generate album title
    let autoTitles = ["Amazing", "Sunny", "Lucky", "Lovely", "Crazy"]
    
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
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayColoredView: UIView!
    @IBOutlet weak var albumTitleTextField: UITextField!
    @IBOutlet weak var createAlbumButton: UIButton!
    
    //MARK: - Outlets Methods
    @IBAction func actionTakePicture(sender: AnyObject) {
        
        cameraManager.capturePictureWithCompletition({
            (img, error) -> Void in
            self.image = img
            
            UIView.setAnimationsEnabled(false)
            self.performSegueWithIdentifier("segueEditCameraImage", sender: nil)
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
    
    @IBAction func createAlbumButtonTapped(sender: UIButton) {
        self.performSegueWithIdentifier("segueChooseContactsAlbumCreation", sender: nil)
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
        if !isLiveAlbumExisting {
            self.overlayView.layer.zPosition = 1
            self.cameraView.layer.zPosition = 0
            self.albumTitleTextField.layer.zPosition = 2
            self.createAlbumButton.layer.zPosition = 2
            self.buttonTakePicture.layer.zPosition = 2
            self.buttonFlash.layer.zPosition = 2
            self.buttonReturnCamera.layer.zPosition = 2
            
            self.buttonAlbumVC.layer.zPosition = 10
            self.buttonProfileVC.layer.zPosition = 10
        }
        else {
            self.cameraView.layer.zPosition = 0
            self.buttonTakePicture.layer.zPosition = 1
            self.buttonFlash.layer.zPosition = 1
            self.buttonReturnCamera.layer.zPosition = 1
            
            self.buttonAlbumVC.layer.zPosition = 10
            self.buttonProfileVC.layer.zPosition = 10
            
            //self.networkStatus.layer.zPosition = 1
        }
    }
    
    func createAlbumInit() {
        //Style of text field
        T_DesignHelper.addSubBorder(self.albumTitleTextField)
        T_DesignHelper.colorPlaceHolder(self.albumTitleTextField)
        T_DesignHelper.addRoundBorder(self.createAlbumButton)
        T_DesignHelper.colorBorderButton(self.createAlbumButton)
        
        //Hide camera view and show overlay
        self.showOverlayView()
        
        self.albumTitleTextField.delegate = self
        
        //Mettre la camera en front pour la prise du selfie
        cameraManager.cameraDevice = .Front
        
        //Need to add color the overlay view
        T_DesignHelper.colorUIView(self.overlayColoredView)
        self.overlayColoredView.alpha = 0.8
        
        //Add the camera preview
        cameraManager.addPreviewLayerToView(self.cameraView)
        
        //self.multiAlbumStatus.hidden = true
        self.networkStatus.hidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        T_CameraViewController.instance = self
        
        // Initilisation du background
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "Splashscreen")!)
        
        //Text field init with random title
        let randomIndex = Int(arc4random_uniform(UInt32(autoTitles.count)))
        self.albumTitleTextField.attributedPlaceholder = NSAttributedString(string:"\(autoTitles[randomIndex]) \(T_DateHelper.getDayOfWeekInLetter())")
        
        // Common camera manager settings
        cameraManager.shouldRespondToOrientationChanges = false
        cameraManager.cameraOutputMode = .StillImage
        cameraManager.cameraOutputQuality = .Medium
        cameraManager.flashMode = .Off
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.showAccessPermissionPopupAutomatically = true
        
        // Camera init if no live album
        if !self.isLiveAlbumExisting {
            createAlbumInit()
        }
            // Camera init if live album
        else {
            //Show camera view and hide overlay
            self.showCameraView()
            cameraManager.cameraDevice = .Back
            cameraManager.addPreviewLayerToView(self.cameraView)
        }
        
        tapOnNetworkStatus.addTarget(self.networkStatus, action: #selector(T_NetworkStatus.pressed))
        self.networkStatus.addGestureRecognizer(tapOnNetworkStatus)
        self.view.addSubview(self.networkStatus)
        
        //        tapOnNetworkStatus.addTarget(self.multiAlbumStatus, action: #selector(T_MultiAlbumStatus.pressed))
        //        self.multiAlbumStatus.addGestureRecognizer(tapOnNetworkStatus)
        //        self.view.addSubview(self.multiAlbumStatus)
        self.view.addSubview(self.modalView)
        
        // Button to quit the creation of a new album
        quitButton.setImage(UIImage(named: "Cancel"), forState: .Normal)
        quitButton.addTarget(self, action: #selector(T_CameraViewController.quitButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.quitButton.hidden = true
        self.view.addSubview(quitButton)
        quitButton.layer.zPosition = 10000
        
        
        // If the application enter in background, we stop the timer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CameraViewController.stopAlbumTimer), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        // If the application is again active, we test once again if the album is existing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CameraViewController.manageAlbumProcessing), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        manageAlbumProcessing()
    }
    
    func showQuitButton() {
        print("ok")
        self.quitButton.hidden = false
    }
    
    func quitButtonPressed() {
        showCameraView()
        self.quitButton.hidden = true
    }
    
    func showOverlayView() {
        self.overlayView.hidden = false
        self.buttonTakePicture.hidden = true
        self.buttonReturnCamera.hidden = true
        self.buttonFlash.hidden = true
    }
    
    func showCameraView() {
        self.overlayView.hidden = true
        self.buttonTakePicture.hidden = false
        self.buttonReturnCamera.hidden = false
        self.buttonFlash.hidden = false
        //        self.multiAlbumStatus.hidden = false
        self.networkStatus.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueEditCameraImage" {
            let destinationVC = segue.destinationViewController as! T_EditCameraImageViewController
            destinationVC.image = self.image
            // To perform symetry / rotation if needed when computing the image for filters
            destinationVC.isFrontCamera = !self.isBackCameraActivated
            destinationVC.post = T_Post.createPost()
        }
        else if segue.identifier == "segueChooseContactsAlbumCreation" {
            let nav = segue.destinationViewController as! UINavigationController
            let destinationVC = nav.topViewController as! T_ChooseContactsAlbumCreationViewController
            
            destinationVC.cover = UIImage(named: "default-cover")
            destinationVC.duration = 3
            if let title = self.albumTitleTextField.text where !title.isEmpty{
                destinationVC.albumTitle = title
            }
            else {
                destinationVC.albumTitle = albumTitleTextField.placeholder!
            }
        }
    }
    
    //MARK: - Methods
    //    func manageAlbumProcessing() {
    //        guard let currentUser = PFUser.currentUser() as? T_User else { return }
    //        
    //        self.isLiveAlbumExisting = false
    //        //self.networkStatus.hide()
    //        
    //        
    //        T_Album.manageAlbumProcessing(currentUser) {
    //            (isLiveAlbum: Bool) -> Void in
    //            
    //            self.isLiveAlbumExisting = isLiveAlbum
    //            
    //            if (isLiveAlbum) {
    //                
    //                guard let album = currentUser.liveAlbum else { return  }
    //                self.showCameraView()
    //                //self.networkStatus.updateLabelText(T_NetworkStatus.status.ShowAlbumTitle, withText: album.title)
    //                self.multiAlbumStatus.updateLabelText(album.title)
    //                
    //                self.albumTimer = NSTimer.scheduledTimerWithTimeInterval(Double(T_Album.getRemainingDuration((currentUser.liveAlbum?.createdAt)!, duration: (currentUser.liveAlbum?.duration)!)), target: self, selector: #selector(T_CameraViewController.manageAlbumProcessing), userInfo: nil, repeats: false)
    //            } else {
    //                self.showOverlayView()
    //            }
    //        }
    //    }
    
    func manageAlbumProcessing() {
        guard let currentUser = PFUser.currentUser() as? T_User else { return }
        
        self.isLiveAlbumExisting = false
        T_Album.manageAlbumsProcessing(currentUser) {
            (isLiveAlbum: Bool) -> Void in
            
            if (isLiveAlbum) {
                
                self.isLiveAlbumExisting = isLiveAlbum
                
                self.albumTimer = NSTimer.scheduledTimerWithTimeInterval(Double(T_Album.getRemainingDuration((currentUser.liveAlbum?.createdAt)!, duration: (currentUser.liveAlbum?.duration)!)), target: self, selector: #selector(T_CameraViewController.manageAlbumProcessing), userInfo: nil, repeats: false)
                
                guard let album = currentUser.liveAlbum else { return  }
                self.showCameraView()
                self.networkStatus.updateLabelText(T_NetworkStatus.status.ShowAlbumTitle, withText: album.title)
                //self.multiAlbumStatus.updateLabelText(album.title)
            }
            else {
                self.showOverlayView()
            }
        }
    }
    
    func updateAlbumStatus() {
        guard let currentUser = PFUser.currentUser() as? T_User else { return }
        self.networkStatus.updateLabelText(T_NetworkStatus.status.ShowAlbumTitle, withText: currentUser.liveAlbum!.title)
        //        self.multiAlbumStatus.updateLabelText(currentUser.liveAlbum!.title)
    }
    
    func stopAlbumTimer() {
        self.albumTimer?.invalidate()
    }
    
    func freezeUI(text: String) {
        
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD?.labelText = text
        progressHUD?.mode = .Indeterminate
        
        buttonTakePicture.hidden = true
        buttonReturnCamera.hidden = true
        buttonFlash.hidden = true
    }
    
    func unfreezeUI(success: Bool = true) {
        if(success) {
            let alertController = UIAlertController(title: NSLocalizedString("Album successfully created !", comment: ""), message:
                NSLocalizedString("Let's share your first picture !", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Go !", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            self.showOverlayView()
            let alertController = UIAlertController(title: NSLocalizedString("Cannot create the album", comment: ""), message:
                NSLocalizedString("Please check your network connection and try again !", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        progressHUD?.hide(true)
    }
}

extension T_CameraViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
