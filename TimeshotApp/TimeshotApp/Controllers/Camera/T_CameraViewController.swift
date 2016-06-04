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
    @IBOutlet weak var createAlbumLabel: UILabel!
    @IBOutlet weak var albumTitleTextField: UITextField!
    @IBOutlet weak var createAlbumButton: UIButton!
    
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
        if !isLiveAlbumExisting {
            self.overlayView.layer.zPosition = 1
            self.cameraView.layer.zPosition = 0
            self.createAlbumLabel.layer.zPosition = 2
            self.albumTitleTextField.layer.zPosition = 2
            self.createAlbumButton.layer.zPosition = 2
            
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
            
            self.networkStatus.layer.zPosition = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        T_CameraViewController.instance = self
        
        // Initilisation du background
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "Splashscreen")!)
        
        // Camera init if no live album
        if !self.isLiveAlbumExisting {
            //Need to hide right buttons and take picture buttons
            self.buttonTakePicture.hidden = true
            self.buttonReturnCamera.hidden = true
            self.buttonFlash.hidden = true
            
            self.albumTitleTextField.delegate = self
            
            //Mettre la camera en front pour la prise du selfie
            cameraManager.cameraDevice = .Front
            
            //Need to add an overlay on the overlay view
            T_DesignHelper.colorUIView(self.overlayColoredView)
            self.overlayColoredView.alpha = 0.8
            self.createAlbumLabel.alpha = 1
            self.albumTitleTextField.alpha = 1
            self.createAlbumButton.alpha = 1
            cameraManager.addPreviewLayerToView(self.cameraView)
            
            //Mettre au premier plan les icones du bas
            self.buttonAlbumVC.hidden = false
            self.buttonProfileVC.hidden = false
            
        }
        // Camera init if live album
        else {
            //Hide overlay, label, text field and album creation buttons
            self.overlayView.hidden = true
            self.buttonTakePicture.hidden = false
            self.buttonReturnCamera.hidden = false
            self.buttonFlash.hidden = false
            
            cameraManager.addPreviewLayerToView(self.cameraView)
            cameraManager.cameraDevice = .Back
        }
        cameraManager.shouldRespondToOrientationChanges = false
        cameraManager.cameraOutputMode = .StillImage
        cameraManager.cameraOutputQuality = .Medium
        cameraManager.flashMode = .Off
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.showAccessPermissionPopupAutomatically = true

        tapOnNetworkStatus.addTarget(self.networkStatus, action: #selector(T_NetworkStatus.pressed))
        self.networkStatus.addGestureRecognizer(tapOnNetworkStatus)
        self.view.addSubview(self.networkStatus)
        
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
        self.networkStatus.hide()

        
        T_Album.manageAlbumProcessing(currentUser) {
            (isLiveAlbum: Bool) -> Void in
            
            self.isLiveAlbumExisting = isLiveAlbum
            
            if (isLiveAlbum) {
                
                guard let album = currentUser.liveAlbum else { return  }

                self.networkStatus.updateLabelText(T_NetworkStatus.status.ShowAlbumTitle, withText: album.title)

                self.albumTimer = NSTimer.scheduledTimerWithTimeInterval(Double(T_Album.getRemainingDuration((currentUser.liveAlbum?.createdAt)!, duration: (currentUser.liveAlbum?.duration)!)), target: self, selector: #selector(T_CameraViewController.manageAlbumProcessing), userInfo: nil, repeats: false)
            }
        }
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
            let alertController = UIAlertController(title: "Album successfully created !", message:
                "Let's share your first picture !", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Go !", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Cannot create the album", message:
                "Please check your network connection and try again !", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        progressHUD?.hide(true)
        
        buttonTakePicture.hidden = false
        buttonReturnCamera.hidden = false
        buttonFlash.hidden = false

    }
}

extension T_CameraViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
