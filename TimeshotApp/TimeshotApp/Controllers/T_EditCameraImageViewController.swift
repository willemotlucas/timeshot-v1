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
    
    @IBOutlet weak var imgv: UIImageView!
    var slider: T_Slider!
    var image:UIImage!
    
    override func viewDidLoad() {
        
        //        imgv.contentMode = .ScaleAspectFill
        //        imgv.image = self.image
        
        let slides = T_Slider.slidesWithFilterFromImage(image)
        self.slider = T_Slider(slides: slides, frame: CGRect(origin: CGPointZero, size: T_EditCameraImageViewController.screenSize), target: self)
        self.slider.show()
        
        let recognizer = UIPanGestureRecognizer(target: self.slider, action: Selector("handleDragging:"))
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(recognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self.slider, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.slider, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let btn: UIButton = UIButton(frame: CGRectMake(10, 10, 30, 30))
        btn.backgroundColor = UIColor.greenColor()
        btn.setTitle("Click Me", forState: UIControlState.Normal)
        btn.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.layer.zPosition = 20
        self.view.addSubview(btn)
        
        let btn2: UIButton = UIButton(frame: CGRectMake(100, 100, 30, 30))
        btn2.backgroundColor = UIColor.greenColor()
        btn2.setTitle("Click Me", forState: UIControlState.Normal)
        btn2.addTarget(self, action: "buttonAction2:", forControlEvents: UIControlEvents.TouchUpInside)
        btn2.layer.zPosition = 20
        self.view.addSubview(btn2)
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
    
    func buttonAction(sender: UIButton!) {
        screenShotMethod()
    }
    
    func buttonAction2(sender: UIButton!) {
        self.dismissViewControllerAnimated(false, completion: {});
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
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
