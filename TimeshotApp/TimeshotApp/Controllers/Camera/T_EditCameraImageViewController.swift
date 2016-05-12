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
    var slider:SNSlider = SNSlider(frame: CGRect(origin: CGPointZero, size: T_DesignHelper.screenSize))
    var textField:SNTextField = SNTextField(y: T_DesignHelper.screenSize.height/2, width: T_DesignHelper.screenSize.width, heightOfScreen: T_DesignHelper.screenSize.height)
    var data:[SNFilter] = []
    var tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()

    
    var image:UIImage!
    var isFrontCamera:Bool!
    var post:T_Post!
    
    //MARK: Outlets properties
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    //MARK: Outlets actions
    @IBAction func actionNext(sender: AnyObject) {
        
        buttonNext.hidden = true
        buttonCancel.hidden = true

        self.post.addPictureToPost(T_CameraHelper.screenShot(self.view))
        T_NetworkManager.sharedInstance.uploadPost(self.post, image: T_CameraHelper.screenShot(self.view))
                
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    @IBAction func actionCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    //MARK: System methods
    override func viewDidLoad() {
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(T_EditCameraImageViewController.handleTap(_:)))
        
        self.initSlider()
        self.initTextField()
        
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

    override func viewDidAppear(animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self.textField)
    }

    func createData() {
        self.data = SNFilter.generateFiltersWithScaling(SNFilter.filterNameList2, image: self.image, isFrontCamera: self.isFrontCamera)
        
        let sticker:SNSticker = SNSticker(frame: CGRect(x: 0, y: 0, width: T_DesignHelper.screenSize.width, height: T_DesignHelper.screenSize.height), image: UIImage(named: "SliderIF2")!)
        // In case of overlapping, you can provide a zPosition (the default one is 0)
        let sticker2:SNSticker = SNSticker(frame: CGRect(x: 0, y: 0, width: T_DesignHelper.screenSize.width, height: T_DesignHelper.screenSize.height), image: UIImage(named: "SliderIF")!)
        let sticker5:SNSticker = SNSticker(frame: CGRect(x: 0, y: 0, width: T_DesignHelper.screenSize.width, height: T_DesignHelper.screenSize.height), image: UIImage(named: "SliderParty")!)
        let sticker6:SNSticker = SNSticker(frame: CGRect(x: 0, y: 0, width: T_DesignHelper.screenSize.width, height: T_DesignHelper.screenSize.height), image: UIImage(named: "SliderBeerTime")!)
        
        self.data[1].addSticker(sticker)
        self.data[2].addSticker(sticker2)
        self.data[5].addSticker(sticker5)
        self.data[6].addSticker(sticker6)
    }

    func initSlider() {
        
        self.createData()
        self.slider.dataSource = self
        self.slider.userInteractionEnabled = true
        self.view.addSubview(slider)
        self.slider.reloadData()
    }
    
    func initTextField() {
        self.textField.layer.zPosition = 100
        self.textField.addGradient(0.7)
        self.view.addSubview(textField)
        
        self.tapGesture.delegate = self
        self.tapGesture.cancelsTouchesInView = false
        self.slider.addGestureRecognizer(tapGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.textField, selector: #selector(SNTextField.keyboardTypeChanged(_:)), name: UIKeyboardDidShowNotification, object: nil)
    }
}

//MARK: - Extension SNSlider DataSource

extension T_EditCameraImageViewController: SNSliderDataSource {
    
    func numberOfSlides(slider: SNSlider) -> Int {
        return data.count
    }
    
    func slider(slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
        
        return data[index]
    }
    
    func startAtIndex(slider: SNSlider) -> Int {
        return 0
    }
    
    func imageFiltered(slider: SNSlider) -> UIImage {
        return image
    }
    
    func filters(slider: SNSlider) -> [String] {
        return SNFilter.filterNameList2
    }
    
    func isFrontCamera(slider: SNSlider) -> Bool {
        return isFrontCamera
    }

}

//MARK: - Extension Gesture Recognizer Delegate and touch Handler for TextField

extension T_EditCameraImageViewController: UIGestureRecognizerDelegate {
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.textField.handleTap()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if (self.buttonCancel.pointInside(touch.locationInView(self.buttonCancel), withEvent: nil) ) {
            actionCancel(self)
            return false
        }
        else if (self.buttonNext.pointInside(touch.locationInView(self.buttonNext), withEvent: nil) ) {
            actionNext(self)
            return false
        }
        return true
    }
}


