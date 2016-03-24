//
//  T_CreateAlbumViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 24/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_CreateAlbumViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image:UIImage!
    var isFrontCamera:Bool = true
    var textField:UITextField!
    let textFieldPosition = T_DesignHelper.screenSize.height/2
    
    override func viewDidLoad() {
        
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        initBackgroundImage()
        initScrollView()
        initTextField()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardTypeChanged:", name: UIKeyboardDidShowNotification, object: nil)
        
        // TODO : 
        // Choisir la durée de l'album
        // Boutons cancel et next
        // TableViewController
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func initBackgroundImage()
    {
        if (isFrontCamera)
        {
            self.imageView.image = T_DesignHelper.flipH(self.image)
        }
        else
        {
            self.imageView.image = self.image
        }
    }
    
    func initScrollView()
    {
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
    
    func initTextField()
    {
        self.textField = UITextField(frame:CGRectMake(0, textFieldPosition, T_DesignHelper.screenSize.width, 40))
        self.textField.attributedPlaceholder = NSAttributedString(string:"Add a title to your new album !",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.textField.font = UIFont.systemFontOfSize(16)
        self.textField.textColor = UIColor.whiteColor()
        self.textField.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        self.textField.borderStyle = UITextBorderStyle.None
        self.textField.autocorrectionType = UITextAutocorrectionType.No
        self.textField.keyboardType = UIKeyboardType.Default
        self.textField.returnKeyType = UIReturnKeyType.Done
        self.textField.clearButtonMode = UITextFieldViewMode.Never;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.textField.delegate = self
        self.view.addSubview(self.textField)
        self.textField.layer.zPosition = 15
        self.textField.textAlignment = .Center
        self.textField.contentHorizontalAlignment = .Center
        self.textField.hidden = false
    }
    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text:NSString = (self.textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        let textSize = text.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16.0)])
        
        return textSize.width <= ((self.scrollView.frame.size.width) - 20)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.textField.frame.origin.y = self.scrollView.frame.size.height - keyboardSize.height - self.textField.frame.size.height
        }
    }
    
    func keyboardTypeChanged(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.textField.frame.origin.y = self.scrollView.frame.size.height - keyboardSize.height - self.textField.frame.size.height
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        self.textField.frame.origin.y = textFieldPosition
    }
    
    
    
}
