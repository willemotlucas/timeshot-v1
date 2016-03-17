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
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var buttonTakePicture: UIButton!
    
    @IBAction func actionTakePicture(sender: AnyObject) {
        
        var image:UIImage?
        cameraManager.capturePictureWithCompletition({
            (img, error) -> Void in
            image = img
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Camera init
        cameraManager.addPreviewLayerToView(self.cameraView)
        self.cameraView.layer.zPosition = 0
        self.buttonTakePicture.layer.zPosition = 1
        
        cameraManager.cameraDevice = .Back
        cameraManager.cameraOutputMode = .StillImage
        cameraManager.cameraOutputQuality = .High
        cameraManager.flashMode = .Off
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.showAccessPermissionPopupAutomatically = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
