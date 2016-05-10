//
//  T_CreateAlbumViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 24/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse

class T_CreateAlbumViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    
    var image:UIImage!
    var isFrontCamera:Bool = true
    var textField:T_SnapTextField!
    var textFieldTitle: UILabel!
    var textFieldTitleBackground: UIView!
    var timePicker:UIPickerView!
    var timePickerTextField:UITextView!
    var duration:Int!
    
    private
    let timeData = [3, 6, 12, 24, 48]
    var defaultDuration:Int!
    
    //------------------------------------------------------------------------------------------------
    //MARK: Outlets Methods
    @IBAction func actionNext(sender: AnyObject) {
        UIView.setAnimationsEnabled(false)
        self.performSegueWithIdentifier("segueChooseContactsAlbumCreation", sender: nil)
    }
    @IBAction func actionCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Systems methods
    
    override func viewDidLoad() {
        
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        self.defaultDuration = timeData[0]
        self.duration = defaultDuration
        
        initBackgroundImage()
        initScrollView()
        initTextField()
        initTimerPicker()
        initButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CreateAlbumViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CreateAlbumViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CreateAlbumViewController.keyboardTypeChanged(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(T_CreateAlbumViewController.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {

        textField.resignFirstResponder();
        timePickerTextField.resignFirstResponder();
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueChooseContactsAlbumCreation") {
            
            let nav = segue.destinationViewController as! UINavigationController
            let destinationVC = nav.topViewController as! T_ChooseContactsAlbumCreationViewController
            
            timePicker.hidden = true
            timePickerTextField.hidden = true
            buttonNext.hidden = true
            buttonBack.hidden = true
            
            textField.hidden = true
                        
            destinationVC.cover = T_CameraHelper.screenShot(self.view)
            destinationVC.duration = self.duration
            destinationVC.albumTitle = (self.textField.text)!
            
            textField.hidden = false

            timePicker.hidden = false
            timePickerTextField.hidden = false
            buttonNext.hidden = false
            buttonBack.hidden = false

        }
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: TimePicker methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return timeData.count
    }

    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(self.timeData[row]) hours", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.timePickerTextField.text = "Duration of the album  \n  \(timeData[row])h"
        self.duration = timeData[row]
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Init methods
    
    func initButton() {
        let a = UIButton(frame: CGRect(x: T_DesignHelper.screenSize.width/2 - 100, y: 13, width: 200, height: 50))
        a.backgroundColor = UIColor.clearColor()
        
        a.setTitle("", forState: UIControlState.Normal)
        a.addTarget(self, action: #selector(T_CreateAlbumViewController.action), forControlEvents: UIControlEvents.TouchUpInside)
        a.layer.zPosition = 20
        
        self.view.addSubview(a)
    }
    
    func action() {
        self.timePickerTextField.becomeFirstResponder()
    }
    
    func initTimerPicker() {
        self.timePickerTextField = UITextView(frame: CGRect(x: T_DesignHelper.screenSize.width/2 - 100, y: 13, width: 200, height: 50))
        self.timePickerTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.timePickerTextField.textColor = UIColor.whiteColor()
        self.timePickerTextField.font = UIFont.systemFontOfSize(16.0)
        self.timePickerTextField.layer.zPosition = 16
        self.timePickerTextField.tintColor = UIColor.clearColor()
        self.timePickerTextField.layer.cornerRadius = 22
        self.timePickerTextField.layer.masksToBounds = true
        self.timePickerTextField.textAlignment = .Center
//        self.timePickerTextField.userInteractionEnabled = true
//        self.timePickerTextField.scrollEnabled = false
//        self.timePickerTextField.editable = false
        self.timePickerTextField.text = "Duration of the album  \n  \(defaultDuration)h"
        self.view.addSubview(self.timePickerTextField)

        self.timePicker = UIPickerView(frame: CGRect(x: 0, y: T_DesignHelper.screenSize.height - 90, width: T_DesignHelper.screenSize.width, height: 90))
        self.timePicker.backgroundColor = UIColor.blackColor()
        self.timePicker.layer.zPosition = 16
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        self.timePickerTextField.inputView = self.timePicker
        self.timePicker.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.translucent = true
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(T_CreateAlbumViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton, spaceButton], animated: false)
        toolBar.userInteractionEnabled = true
        self.timePickerTextField.inputAccessoryView = toolBar
    }
    
    func donePicker() {
        self.timePickerTextField.resignFirstResponder();
    }
    
    func initBackgroundImage() {
        if (isFrontCamera)
        {
            self.imageView.image = T_DesignHelper.flipH(self.image)
        }
        else
        {
            self.imageView.image = self.image
        }
    }
    
    func initScrollView() {
        //scrollView.layer.zPosition = 14
        
        let arraySlider = ["SliderParty","SliderVac","SliderAlbum","SliderPic"]
        
        for i in 0..<arraySlider.count {
            // Need to create the view
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(i)
            frame.origin.y = 0.0
            
            // Design of the view
            let newPageView = UIImageView()
            newPageView.image = UIImage(named: arraySlider[i])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            
            scrollView.addSubview(newPageView)
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, self.scrollView.frame.height)
        self.scrollView.delegate = self
    }
    
    func initTextField() {
        self.textField = T_SnapTextField(frame: CGRectMake(0, 3*T_DesignHelper.screenSize.height/5, T_DesignHelper.screenSize.width, 40), target: self.view,  parentFrameSize: self.view.frame)
        self.textField.hidden = false
        self.textField.shouldHide = false
        self.textField.setPlaceHolder("")
        
        
        self.textFieldTitle = UILabel(frame: CGRectMake(0, 3*T_DesignHelper.screenSize.height/5-self.textField.frame.size.height, T_DesignHelper.screenSize.width, 40))
        self.textFieldTitle.text = "Title of your album"
        self.textFieldTitle.textColor = UIColor.whiteColor()
        self.textFieldTitle.textAlignment = .Center
        self.textFieldTitle.layer.zPosition = 15
        
        self.textFieldTitleBackground = UIView(frame: CGRectMake(0, 3*T_DesignHelper.screenSize.height/5-self.textField.frame.size.height, T_DesignHelper.screenSize.width, 40))
        self.textFieldTitleBackground.layer.zPosition = 14
        self.textFieldTitleBackground.alpha = 0.7
        self.textFieldTitleBackground.backgroundColor = UIColor.clearColor()
        self.textFieldTitleBackground.layer.insertSublayer(T_DesignHelper.createGradientLayer(CGRect(x: 0, y: 0, width: T_DesignHelper.screenSize.width, height: self.textFieldTitleBackground.frame.size.height)), atIndex: 0)
    
        self.view.addSubview(textFieldTitle)
        self.view.addSubview(textFieldTitleBackground)

    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Keyboard Behaviour
    
    func keyboardWillShow(notification: NSNotification) {
        
        if(self.timePickerTextField.isFirstResponder()) {
            let alertController = UIAlertController(title: "Choose the duration of the album !", message:
                "This duration will allow participant to put pictures in it ! Don’t worry this album won’t be delete after this time !", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK !", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        
        if (self.textField.isFirstResponder() == true)
        {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                self.textField.frame.origin.y = T_DesignHelper.screenSize.height - keyboardSize.height - self.textField.frame.size.height
                self.textFieldTitle.frame.origin.y = self.textField.frame.origin.y - self.textField.frame.size.height
                self.textFieldTitleBackground.frame.origin.y = self.textFieldTitle.frame.origin.y
            }
            
            // If the user change from the TimePickerTextField Keyboard directly to the textField Keyboard, we have to replace the origin position of TimePickerTextField :
            //resetOriginTimePickerTextField()
        }
//        else if (self.timePickerTextField.isFirstResponder() == true)
//        {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//                self.timePickerTextField.frame.origin.y = self.scrollView.frame.size.height - keyboardSize.height - self.timePickerTextField.frame.size.height - 20
//            }
//        }
    }
    
    func keyboardTypeChanged(notification: NSNotification) {
        if (self.textField.isFirstResponder() == true)
        {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                self.textField.frame.origin.y = T_DesignHelper.screenSize.height - keyboardSize.height - self.textField.frame.size.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (self.textField.isFirstResponder() == true)
        {
            self.textField.frame.origin.y = self.textField.lastPosition.y
            self.textFieldTitle.frame.origin.y = self.textField.lastPosition.y - self.textField.frame.size.height
            self.textFieldTitleBackground.frame.origin.y = self.textField.lastPosition.y  - self.textField.frame.size.height
        }
        // On ne veut rien changer normalement par rapport a notre durationTextField
//        else if (self.timePickerTextField.isFirstResponder() == true)
//        {
//            resetOriginTimePickerTextField()
//        }
        
        
        if (self.textField.text?.isEmpty == true) {
            self.buttonNext.hidden = true
        }
        else {
            self.buttonNext.hidden = false
        }
    }
    
    // On veut le laisser en haut notre textField pour la duration
//    func resetOriginTimePickerTextField() {
//        self.timePickerTextField.frame.origin.y = T_DesignHelper.screenSize.height - 20 - 44
//    }
    
}
