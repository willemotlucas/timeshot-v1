//
//  T_EditCameraImageViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 17/03/2016.
//  Copyright © 2016 Timeshot. All righT_ reserved.
//

import UIKit

class T_EditCameraImageViewController: UIViewController {
    
    //MARK: Properties
    var slider: T_Slider!
    var image:UIImage!
    var isFrontCamera:Bool!
    
    //MARK: Outlets properties
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    //MARK: Outlets actions
    @IBAction func actionNext(sender: AnyObject) {
        T_CameraHelper.screenShot(self.view)
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    @IBAction func actionCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    //MARK: System methods
    override func viewDidLoad() {
        
        // Init and show the slider, composed by filters created from the image
        self.slider = T_Slider(image: image, isFrontCamera: isFrontCamera, frame: CGRect(origin: CGPointZero, size: T_DesignHelper.screenSize), target: self)
        self.slider.show()
        
        // Init the gesture recognizer to detect swipe / finger movements on the screen
        let recognizer = UIPanGestureRecognizer(target: self.slider, action: #selector(T_Slider.handleDragging(_:)))
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(recognizer)
        
        // Init keyboard observer to manage correctly the keyboard behaviour
        NSNotificationCenter.defaultCenter().addObserver(self.slider.textField, selector: #selector(T_SnapTextField.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.slider.textField, selector: #selector(T_SnapTextField.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.slider.textField, selector: #selector(T_SnapTextField.keyboardTypeChanged(_:)), name: UIKeyboardDidShowNotification, object: nil)

        // Update button's zPosition to put them over the slider
        self.buttonCancel.layer.zPosition = 20
        self.buttonNext.layer.zPosition = 20
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self.slider)
    }
    
    deinit {
    }
        
    //MARK: - Touch Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.slider.touchesBegan((touches.first?.locationInView(self.view))!)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.slider.touchesEndedWithUpdate((touches.first?.locationInView(self.view))!)
    }
}
