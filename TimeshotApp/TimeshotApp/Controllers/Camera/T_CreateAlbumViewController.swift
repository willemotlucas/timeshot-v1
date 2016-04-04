//
//  T_CreateAlbumViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 24/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_CreateAlbumViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonNext: UIButton!
    
    var image:UIImage!
    var isFrontCamera:Bool = true
    var textField:T_SnapTextField!
    var timePicker:UIPickerView!
    var timePickerTextField:UITextField!
    
    private
    let timeData = [3, 6, 12, 24, 48]
    
    
    //------------------------------------------------------------------------------------------------
    //MARK: Outlets Methods
    @IBAction func actionNext(sender: AnyObject) {
        self.performSegueWithIdentifier("segueChooseContactsAlbumCreation", sender: nil)
    }
    @IBAction func actionCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Systems methods
    
    override func viewDidLoad() {
        
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        initBackgroundImage()
        initScrollView()
        initTextField()
        initTimerPicker()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CreateAlbumViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CreateAlbumViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(T_CreateAlbumViewController.keyboardTypeChanged(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(T_CreateAlbumViewController.handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    deinit
    {

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
        self.timePickerTextField.text = "\(timeData[row])h"
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Init methods
    func initTimerPicker() {
        self.timePickerTextField = UITextField(frame: CGRect(x: T_DesignHelper.screenSize.width/2 - 22, y: T_DesignHelper.screenSize.height - 20 - 44, width: 44, height: 44))
        self.timePickerTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.timePickerTextField.textColor = UIColor.whiteColor()
        self.timePickerTextField.layer.zPosition = 16
        self.timePickerTextField.layer.cornerRadius = 22
        self.timePickerTextField.layer.masksToBounds = true
        self.timePickerTextField.textAlignment = .Center
        self.timePickerTextField.text = "\(timeData[0])h"
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
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let NewAlbumImage = UIImage(named: "NewAlbum")
        scrollView.layer.zPosition = 14
        let imageView1 = UIImageView(frame: CGRect(x: 40, y: 300, width: (NewAlbumImage?.size.width)!, height: (NewAlbumImage?.size.height)!))
        imageView1.image = NewAlbumImage
        let imageView2 = UIImageView(frame: CGRect(x: scrollViewWidth + 40, y: 400, width: (NewAlbumImage?.size.width)!, height: (NewAlbumImage?.size.height)!))
        imageView2.image = NewAlbumImage
        let imageView3 = UIImageView(frame: CGRect(x: 2*scrollViewWidth + 40, y: 500, width: (NewAlbumImage?.size.width)!, height: (NewAlbumImage?.size.height)!))
        imageView3.image = NewAlbumImage
        let imageView4 = UIImageView(frame: CGRect(x: 3*scrollViewWidth + 40, y: 450, width: (NewAlbumImage?.size.width)!, height: (NewAlbumImage?.size.height)!))
        imageView4.image = NewAlbumImage
        
        self.scrollView.addSubview(imageView1)
        self.scrollView.addSubview(imageView2)
        self.scrollView.addSubview(imageView3)
        self.scrollView.addSubview(imageView4)
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, self.scrollView.frame.height)
        self.scrollView.delegate = self
    }
    
    func initTextField() {
        self.textField = T_SnapTextField(frame: CGRectMake(0, T_DesignHelper.screenSize.height/2, T_DesignHelper.screenSize.width, 40), target: self.view,  parentFrameSize: self.view.frame)
        self.textField.hidden = false
        self.textField.shouldHide = false
        self.textField.setPlaceHolder("Title of your album")
    }
    
    //------------------------------------------------------------------------------------------------
    //MARK: Keyboard Behaviour
    
    func keyboardWillShow(notification: NSNotification) {
        if (self.textField.isFirstResponder() == true)
        {
            self.textField.updatePosition(notification)
            
            // If the user change from the TimePickerTextField Keyboard directly to the textField Keyboard, we have to replace the origin position of TimePickerTextField :
            resetOriginTimePickerTextField()
        }
        else if (self.timePickerTextField.isFirstResponder() == true)
        {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.timePickerTextField.frame.origin.y = self.scrollView.frame.size.height - keyboardSize.height - self.timePickerTextField.frame.size.height - 20
            }
        }
    }
    
    func keyboardTypeChanged(notification: NSNotification) {
        if (self.textField.isFirstResponder() == true)
        {
            self.textField.updatePosition(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (self.textField.isFirstResponder() == true)
        {
            self.textField.frame.origin.y = self.textField.lastPosition.y
        }
        else if (self.timePickerTextField.isFirstResponder() == true)
        {
            resetOriginTimePickerTextField()
        }
        
        
        if (self.textField.text?.isEmpty == true) {
            self.buttonNext.hidden = true
        }
        else {
            self.buttonNext.hidden = false
        }
    }
    
    func resetOriginTimePickerTextField() {
        self.timePickerTextField.frame.origin.y = T_DesignHelper.screenSize.height - 20 - 44
    }
    
}
