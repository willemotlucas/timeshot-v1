//
//  T_EditCameraImageViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 17/03/2016.
//  Copyright © 2016 Timeshot. All righT_ reserved.
//

import UIKit

class T_EditCameraImageViewController: UIViewController {
    
    static let screenSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    
    var slider: T_Slider!
    var image:UIImage!
    var isFrontCamera:Bool!
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBAction func actionNext(sender: AnyObject) {
        screenShotMethod()
    }
    
    @IBAction func actionCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    
    
    override func viewDidLoad() {
        
        let slides = T_Slider.slidesWithFilterFromImage(image, isFrontCamera: isFrontCamera)
        self.slider = T_Slider(slides: slides, frame: CGRect(origin: CGPointZero, size: T_EditCameraImageViewController.screenSize), target: self)
        self.slider.show()
        
        let recognizer = UIPanGestureRecognizer(target: self.slider, action: Selector("handleDragging:"))
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(recognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self.slider, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.slider, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.slider, selector: "keyboardTypeChanged:", name: UIKeyboardDidShowNotification, object: nil)
        
        self.buttonCancel.layer.zPosition = 20
        self.buttonNext.layer.zPosition = 20
        
    }
    
    //MARK: ScreenShot tools
    func screenShotMethod() {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    //MARK: - Touch EvenT_
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.slider.touchesBegan((touches.first?.locationInView(self.view))!)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.slider.touchesEndedWithUpdate((touches.first?.locationInView(self.view))!)
    }
    
    //MARK: - Systems methods
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self.slider)
    }
    
}
