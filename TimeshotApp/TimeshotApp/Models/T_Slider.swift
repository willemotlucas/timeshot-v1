//
//  T_Slider.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 24/03/2016.
//  Copyright © 2016 Timeshot. All righT_ reserved.
//

import UIKit

class T_Slider: NSObject, UITextFieldDelegate {
    
    //MARK: Properties
    var target: T_EditCameraImageViewController!
    var slides:[T_Filter]!
    var frame: CGRect?
    var swipeThreshold:CGFloat = 500
    var animation = NSTimer()
    var currentIndex = 0
    var textField:UITextField!
    
    private
    var currentTouchLocation = CGPointZero
    var firstTouchLocation = CGPointZero
    var deltaLocation:CGFloat = 0
    var exFilterWidth:CGFloat = 0
    var touchInTextField:Bool = false
    var textFieldPosition:CGPoint = CGPointZero
    var textFieldWidth:CGFloat = 1.0
    
    enum filterAnimation: Int {
        case attractedToRight = 1
        case attractedToLeft = 2
        case dismissToRight = 3
        case dismissToLeft = 4
    }
    
    static let filterNameList = ["No Filter" ,"CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant"]
    //    static let filterNameList = ["No Filter" ,"CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]
    
    //MARK: Static methods
    static func slidesWithFilterFromImage(image: UIImage, isFrontCamera: Bool) -> [T_Filter]
    {
        var slides:[T_Filter] = []
        for filter in filterNameList
        {
            if filter == "No Filter" {
                // set image selected image
                
                if (isFrontCamera)
                {
                    slides.append(T_Filter(frame: CGRect(origin: CGPointZero, size: T_EditCameraImageViewController.screenSize), image: T_DesignHelper.flipH(image)))
                }
                else
                {
                    slides.append(T_Filter(frame: CGRect(origin: CGPointZero, size: T_EditCameraImageViewController.screenSize), image: image))
                }
            }
            else
            {
                // Create and apply filter
                // 1 - create source image
                let sourceImage = CIImage(image: image)
                
                // 2 - create filter using name
                let myFilter = CIFilter(name: filter)
                myFilter?.setDefaults()
                
                // 3 - set source image
                myFilter?.setValue(sourceImage, forKey: kCIInputImageKey)
                
                // 4 - create core image context
                let context = CIContext(options: nil)
                
                // 5 - output filtered image as cgImage with dimension.
                let outputCGImage = context.createCGImage(myFilter!.outputImage!, fromRect: myFilter!.outputImage!.extent)
                
                // 6 - convert filtered CGImage to UIImage
                var filteredImage = UIImage(CGImage: outputCGImage, scale: 1.0, orientation: UIImageOrientation.Right)
                if (isFrontCamera)
                {
                    filteredImage = T_DesignHelper.flipH(filteredImage)
                }
                
                // 7 - set filtered image to array
                slides.append(T_Filter(frame: CGRect(origin: CGPointZero, size: T_EditCameraImageViewController.screenSize), image: filteredImage))
            }
        }
        
        return slides
    }
    
    
    //MARK: Constructor
    init(slides: [T_Filter], frame: CGRect, target: T_EditCameraImageViewController) {
        super.init()
        
        // At least 2 T_Filter or crash
        self.frame = frame
        self.slides = slides
        self.target = target
        self.textField = UITextField(frame: CGRectMake(0, 100, self.frame!.width, 40))
        self.textField.hidden = true
        self.initTextField()
    }
    
    //MARK: Init Methods
    func show()
    {
        initFiltersMask()
        
        self.target.view.addSubview(slides[currentIndex])
        self.target.view.addSubview(slides[nextIndex()])
        self.target.view.addSubview(slides[previousIndex()])
    }
    
    func initFiltersMask()
    {
        slides[currentIndex].mainFilterInit()
        slides[nextIndex()].rightSideFilterInit()
        slides[previousIndex()].leftSideFilterInit()
        self.exFilterWidth = 0
    }
    
    //MARK: Methods
    func nextIndex() -> Int
    {
        let nextIndex = currentIndex + 1
        
        if (nextIndex == slides.count)
        {
            return 0
        }
        else
        {
            return nextIndex
        }
    }
    
    func previousIndex() -> Int
    {
        let previousIndex = currentIndex - 1
        
        if (previousIndex == -1)
        {
            return (slides.count - 1)
        }
        else
        {
            return previousIndex
        }
    }
    
    //MARK: Animation methods
    
    func filterApplied(leftFilter: Bool)
    {
        if (leftFilter == true)
        {
            self.currentIndex = previousIndex()
            self.show()
        }
        else
        {
            self.currentIndex = nextIndex()
            self.show()
        }
    }
    
    func updateMaskFilter()
    {
        self.deltaLocation = self.currentTouchLocation.x - self.firstTouchLocation.x + self.exFilterWidth
        if (self.deltaLocation  >= 0)
        {
            // Filtre gauche qui s'applique vers la droite
            self.slides[previousIndex()].leftSideFilterUpdate(self.deltaLocation)
            self.slides[nextIndex()].rightSideFilterInit()
        }
        else
        {
            // Filtre droite qui s'applique vers la gauche
            self.slides[nextIndex()].rightSideFilterUpdate(self.deltaLocation)
            self.slides[previousIndex()].leftSideFilterInit()
        }
        
    }
    
    func selectAnimation(endPoint: CGPoint) -> filterAnimation
    {
        if(self.deltaLocation >= ((self.frame?.width)!/2)) {
            return .attractedToRight
        }
        else if(self.deltaLocation <= (-(self.frame?.width)!/2)) {
            return .attractedToLeft
        }
        else if(self.deltaLocation >= 0) {
            return .dismissToLeft
        }
        else if(self.deltaLocation <= 0) {
            return .dismissToRight
        }
        else {
            return .dismissToLeft
        }
    }
    
    func startAnimation(animationToProcess: filterAnimation)
    {
        switch (animationToProcess) {
        case .attractedToRight:
            self.animation = NSTimer.scheduledTimerWithTimeInterval(0.0007, target:self, selector: Selector("animating:"), userInfo: "animateLeftFilterToRight", repeats: true)
            break
            
        case .attractedToLeft:
            self.animation = NSTimer.scheduledTimerWithTimeInterval(0.0007, target:self, selector: Selector("animating:"), userInfo: "animateRightFilterToLeft", repeats: true)
            break
            
        case .dismissToLeft:
            self.animation = NSTimer.scheduledTimerWithTimeInterval(0.0007, target:self, selector: Selector("animating:"), userInfo: "leftFilterGoBackLeft", repeats: true)
            break
            
        case .dismissToRight:
            self.animation = NSTimer.scheduledTimerWithTimeInterval(0.0007, target:self, selector: Selector("animating:"), userInfo: "rightFilterGoBackRight", repeats: true)
            break
        }
    }
    
    func animating(timer: NSTimer)
    {
        switch (timer.userInfo as! String) {
        case "animateLeftFilterToRight":
            if (self.slides[previousIndex()].animate("animateLeftFilterToRight") == false)
            {
                self.animation.invalidate()
                self.filterApplied(true)
            }
            break
        case "leftFilterGoBackLeft":
            if (self.slides[previousIndex()].animate("leftFilterGoBackLeft") == false)
            {
                self.animation.invalidate()
                self.slides[previousIndex()].leftSideFilterInit()
                self.exFilterWidth = 0
            }
            
            break
        case "animateRightFilterToLeft":
            if(self.slides[nextIndex()].animate("animateRightFilterToLeft") == false)
            {
                self.animation.invalidate()
                self.filterApplied(false)
            }
            
            break
        case "rightFilterGoBackRight":
            if (self.slides[nextIndex()].animate("rightFilterGoBackRight") == false)
            {
                self.animation.invalidate()
                self.slides[nextIndex()].rightSideFilterInit()
                self.exFilterWidth = 0
            }
            
            break
        default:
            
            break
        }
    }
    
    func selectSwipeAnimation(toRight: Bool) -> filterAnimation
    {
        if (self.slides[previousIndex()].maskSize?.width != 0)
        {
            if(toRight == true) {
                return .attractedToRight
            }
            else {
                return .dismissToLeft
            }
        }
        else if (self.slides[nextIndex()].maskSize?.width != 0)
        {
            if(toRight == true) {
                return .dismissToRight
            }
            else {
                return .attractedToLeft
            }
        }
        else if(toRight == true) {
            return .attractedToRight
        }
        else {
            return .attractedToLeft
        }
    }
    
    //MARK: Text Input
    
    func initTextField()
    {
        self.textField.frame.origin.y = self.currentTouchLocation.y
        self.textField.placeholder = ""
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
        self.target.view.addSubview(self.textField)
        self.textField.layer.zPosition = 15
        self.textField.textAlignment = .Center
        self.textField.contentHorizontalAlignment = .Center
    }
    
    func showTextInput()
    {
        if(self.currentTouchLocation.y < 0)
        {
            self.textFieldPosition.y = 0
            self.textField.frame.origin.y = 0
        }
        else if(self.currentTouchLocation.y <= ((self.frame?.height)! - 40))
        {
            self.textFieldPosition = self.currentTouchLocation
            self.textField.frame.origin.y = self.textFieldPosition.y
        }
        else
        {
            self.textFieldPosition.y = (self.frame?.height)! - 40
            self.textField.frame.origin.y = (self.frame?.height)! - 40
        }
        
        self.textField.hidden = false
        self.textField.becomeFirstResponder()
    }
    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (self.textField.text == "")
        {
            self.textField.hidden = true
        }
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
        self.textFieldWidth = textSize.width
        
        return textSize.width <= ((self.frame?.width)! - 20)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.textField.frame.origin.y = self.frame!.size.height - keyboardSize.height - self.textField.frame.size.height
        }
    }
    
    func keyboardTypeChanged(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.textField.frame.origin.y = self.frame!.size.height - keyboardSize.height - self.textField.frame.size.height
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        self.textField.frame.origin.y = self.textFieldPosition.y
    }
    
    //MARK: Touches events
    
    func touchesBegan(touch: CGPoint)
    {
        animation.invalidate()
        firstTouchLocation = touch
        
        if (((self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!) == 0)
        {
            currentTouchLocation = touch
            updateMaskFilter()
        }
        
        self.exFilterWidth = (self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!
    }
    
    // Quand un tap à été fait à l'écran (donc sans mouvement, ce qui n'est pas pris pas UIPanGesture)
    func touchesEndedWithUpdate(touch: CGPoint)
    {
        if (((((self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!) == 0)) && (self.textField.hidden == true))
        {
            showTextInput()
        }
        else if (((((self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!) == 0)) && (self.textField.hidden == false))
        {
            textField.resignFirstResponder();
        }
        else
        {
            updateMaskFilter()
            touchesEnded(touch)
        }
    }
    
    func touchesEnded(touch: CGPoint)
    {
        let endPoint = touch
        let animationToProcess = selectAnimation(endPoint)
        self.touchInTextField = false
        startAnimation(animationToProcess)
    }
    
    func touchesEndedWithSwipe(toRight: Bool)
    {
        let animationToProcess = selectSwipeAnimation(toRight)
        startAnimation(animationToProcess)
    }
    
    func handleDragging(recognizer: UIPanGestureRecognizer) {
        
        self.currentTouchLocation = recognizer.locationInView(recognizer.view?.superview)
        
        if (((((self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!) == 0) && (CGRectContainsPoint(self.textField.frame, self.currentTouchLocation))) || (self.touchInTextField == true))
        {
            if ((recognizer.state == .Ended) || (recognizer.state == .Cancelled) || (recognizer.state == .Failed))
            {
                self.touchInTextField = false
            }
            else
            {
                self.touchInTextField = true
                if(self.currentTouchLocation.y < 0)
                {
                    self.textFieldPosition.y = 0
                    self.textField.frame.origin.y = 0
                }
                else if(self.currentTouchLocation.y <= ((self.frame?.height)! - 40))
                {
                    self.textFieldPosition = self.currentTouchLocation
                    self.textField.frame.origin.y = self.textFieldPosition.y
                }
                else
                {
                    self.textFieldPosition.y = (self.frame?.height)! - 40
                    self.textField.frame.origin.y = (self.frame?.height)! - 40
                }
            }
        }
        else
        {
            updateMaskFilter()
            
            if ((recognizer.state == .Ended) || (recognizer.state == .Cancelled) || (recognizer.state == .Failed))
            {
                let velocity = recognizer.velocityInView(recognizer.view?.superview)
                
                if(velocity.x >= swipeThreshold) {
                    // Swipe vers la droite
                    touchesEndedWithSwipe(true)
                }
                else if (velocity.x <= -swipeThreshold) {
                    // Swipe vers la droite
                    touchesEndedWithSwipe(false)
                }
                else
                {
                    touchesEnded(self.currentTouchLocation)
                }
            }
        }
    }
}
