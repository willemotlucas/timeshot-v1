//
//  T_CameraViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 17/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import CameraManager

class T_CameraViewController: UIViewController {
    
    let cameraManager = CameraManager()
    var image:UIImage?
    
    let createAlbum:Bool = true
    
    private
    var isFlashActivated:Bool = false
    var isBackCameraActivated:Bool = true
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var buttonTakePicture: UIButton!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    @IBOutlet weak var buttonReturnCamera: UIButton!
    @IBOutlet weak var buttonFlash: UIButton!
    
    
    @IBAction func actionTakePicture(sender: AnyObject) {
        
        cameraManager.capturePictureWithCompletition({
            (img, error) -> Void in
            self.image = img
            
            if (self.createAlbum == true)
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
        
        setLabelText("Soirées des finaux 2016")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Camera init
        cameraManager.addPreviewLayerToView(self.cameraView)
        cameraManager.cameraDevice = .Back
        cameraManager.cameraOutputMode = .StillImage
        cameraManager.cameraOutputQuality = .High
        cameraManager.flashMode = .Off
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.showAccessPermissionPopupAutomatically = true
    }
    
    func setLabelText(text: String)
    {
        let finalText = "    \(text.trunc(30))"
        let textSize = finalText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15.0)])
        self.albumTitle.frame.size.width = 55 + textSize.width
        self.albumTitle.frame.origin = CGPoint(x: T_EditCameraImageViewController.screenSize.width/2 - self.albumTitle.frame.size.width/2, y: self.albumTitle.frame.origin.y)
        
        self.albumImage.frame.origin = CGPoint(x: T_EditCameraImageViewController.screenSize.width/2 + self.albumTitle.frame.size.width/2 - 40, y: self.albumImage.frame.origin.y)
        
        self.albumTitle.layer.zPosition = 1
        self.albumTitle.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
        self.albumTitle.layer.cornerRadius = 15
        self.albumTitle.font = UIFont.systemFontOfSize(15)
        self.albumTitle.textColor = UIColor.whiteColor()
        self.albumTitle.layer.masksToBounds = true
        self.albumImage.layer.zPosition = 11
        self.albumTitle.text = finalText
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (self.createAlbum == true)
        {
            let destinationVC = segue.destinationViewController as! T_CreateAlbumViewController
            destinationVC.image = self.image
            destinationVC.isFrontCamera = !self.isBackCameraActivated
        }
        else
        {
            let destinationVC = segue.destinationViewController as! T_EditCameraImageViewController
            destinationVC.image = self.image
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
