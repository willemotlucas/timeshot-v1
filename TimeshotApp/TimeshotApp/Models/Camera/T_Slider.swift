//
//  T_Slider.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 24/03/2016.
//  Copyright © 2016 Timeshot. All righT_ reserved.
//

import UIKit

class T_Slider: UIView {
    
    //MARK: Properties
    unowned var target: T_EditCameraImageViewController
    var slides:[T_Filter]!
    var swipeThreshold:CGFloat = 500
    var animation = NSTimer()
    var currentIndex = 0
    var textField:T_SnapTextField!
    
    private
    var currentTouchLocation = CGPointZero
    var firstTouchLocation = CGPointZero
    var deltaLocation:CGFloat = 0
    var exFilterWidth:CGFloat = 0
    
    enum filterAnimation: Int {
        case attractedToRight = 1
        case attractedToLeft = 2
        case dismissToRight = 3
        case dismissToLeft = 4
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK: Static methods
    static let filterNameList = ["No Filter" ,"CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant"]
    //    static let filterNameList = ["No Filter" ,"CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]
    
    // Render filters from an image
    static func slidesWithFilterFromImage(image: UIImage, isFrontCamera: Bool) -> [T_Filter] {
        var slides:[T_Filter] = []
        for filter in filterNameList
        {
            if filter == "No Filter" {
                // set image selected image
                
                if (isFrontCamera)
                {
                    slides.append(T_Filter(frame: CGRect(origin: CGPointZero, size: T_DesignHelper.screenSize), image: T_DesignHelper.flipH(image)))
                }
                else
                {
                    slides.append(T_Filter(frame: CGRect(origin: CGPointZero, size: T_DesignHelper.screenSize), image: image))
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
                slides.append(T_Filter(frame: CGRect(origin: CGPointZero, size: T_DesignHelper.screenSize), image: filteredImage))
            }
        }
        
        return slides
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK: Constructors
    // Init the slider from filters
    init(slides: [T_Filter], frame: CGRect, target: T_EditCameraImageViewController) {
        // At least 2 T_Filter or crash
        self.slides = slides
        self.target = target
        super.init(frame: frame)

        self.frame = frame
        self.textField = T_SnapTextField(frame: CGRectMake(0, 100, self.frame.width, 40), target: self.target.view, parentFrameSize: self.frame)
        self.textField.hidden = true
    }

    // Init the slider from an image, creating the slides itself
    init(image: UIImage, isFrontCamera: Bool, frame: CGRect, target: T_EditCameraImageViewController) {
        
        self.slides = T_Slider.slidesWithFilterFromImage(image, isFrontCamera: isFrontCamera)
        self.target = target
        super.init(frame: frame)
        
        self.frame = frame
        self.textField = T_SnapTextField(frame: CGRectMake(0, 100, self.frame.width, 40), target: self.target.view, parentFrameSize: self.frame)
        self.textField.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {

    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK: Init Methods
    // Show the slider
    func show() {
        initFiltersMask()
        
        self.target.view.addSubview(slides[currentIndex])
        self.target.view.addSubview(slides[nextIndex()])
        self.target.view.addSubview(slides[previousIndex()])
    }
    
    // Init 3 filters on the screen with differents masks initialization (one on the right, left and middle)
    func initFiltersMask() {
        slides[currentIndex].mainFilterInit()
        slides[nextIndex()].rightSideFilterInit()
        slides[previousIndex()].leftSideFilterInit()
        self.exFilterWidth = 0
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK: Methods
    func nextIndex() -> Int {
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
    
    func previousIndex() -> Int {
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
    
    //----------------------------------------------------------------------------------------------------
    //MARK: Animation methods
    
    // When a filter is applied on the entire screen (to replace this filter as the main filter on the screen)
    func filterApplied(leftFilter: Bool) {
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
    
    // Update the filter's mask
    func updateMaskFilter() {
        self.deltaLocation = self.currentTouchLocation.x - self.firstTouchLocation.x + self.exFilterWidth
        if (self.deltaLocation  >= 0)
        {
            // Left filter going to the right
            self.slides[previousIndex()].leftSideFilterUpdate(self.deltaLocation)
            self.slides[nextIndex()].rightSideFilterInit()
        }
        else
        {
            // Right filter going to the left
            self.slides[nextIndex()].rightSideFilterUpdate(self.deltaLocation)
            self.slides[previousIndex()].leftSideFilterInit()
        }
        
    }
    
    // Selecting the animation according to the last point touched, without swipe
    func selectAnimation(endPoint: CGPoint) -> filterAnimation {
        if(self.deltaLocation >= (self.frame.width/2)) {
            return .attractedToRight
        }
        else if(self.deltaLocation <= (-self.frame.width/2)) {
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
    
    // Starting the animation for a special filter
    func startAnimation(animationToProcess: filterAnimation) {
        switch (animationToProcess) {
        case .attractedToRight:
            self.animation = NSTimer.scheduledTimerWithTimeInterval(0.0007, target:self, selector: #selector(T_Slider.animating(_:)), userInfo: "animateLeftFilterToRight", repeats: true)
            break
            
        case .attractedToLeft:
            self.animation = NSTimer.scheduledTimerWithTimeInterval(0.0007, target:self, selector: #selector(T_Slider.animating(_:)), userInfo: "animateRightFilterToLeft", repeats: true)
            break
            
        case .dismissToLeft:
            self.animation = NSTimer.scheduledTimerWithTimeInterval(0.0007, target:self, selector: #selector(T_Slider.animating(_:)), userInfo: "leftFilterGoBackLeft", repeats: true)
            break
            
        case .dismissToRight:
            self.animation = NSTimer.scheduledTimerWithTimeInterval(0.0007, target:self, selector: #selector(T_Slider.animating(_:)), userInfo: "rightFilterGoBackRight", repeats: true)
            break
        }
    }
    
    // Managing the animation timer
    func animating(timer: NSTimer) {
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
    
    // Selecting the animation after a swipe
    func selectSwipeAnimation(toRight: Bool) -> filterAnimation {
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
    
    //----------------------------------------------------------------------------------------------------
    //MARK: - Touches events
    func touchesBegan(touch: CGPoint) {
        animation.invalidate()
        firstTouchLocation = touch
        
        // If any filter is visible
        if (((self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!) == 0)
        {
            currentTouchLocation = touch
            updateMaskFilter()
        }
        
        self.exFilterWidth = (self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!
    }
    
    // When a tap on the screen happens (not managed by UIGesture)
    func touchesEndedWithUpdate(touch: CGPoint) {
        // If no filter and no textfield = show the textfield
        if (((((self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!) == 0)) && (self.textField.hidden == true))
        {
            self.textField.showTextInput(self.currentTouchLocation)
        }
        // If no filter and textfield = hide the keyboard
        else if (((((self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!) == 0)) && (self.textField.hidden == false))
        {
            textField.hideKeyboard();
        }
        // Update Masks and call touchEnded
        else
        {
            updateMaskFilter()
            touchesEnded(touch)
        }
    }
    
    // Select the right animation to execute and animate the filter, without swipe
    func touchesEnded(touch: CGPoint) {
        let endPoint = touch
        let animationToProcess = selectAnimation(endPoint)
        self.textField.touched = false
        startAnimation(animationToProcess)
    }
    
    // Start animation with a swipe
    func touchesEndedWithSwipe(toRight: Bool) {
        let animationToProcess = selectSwipeAnimation(toRight)
        startAnimation(animationToProcess)
    }
    
    func handleDragging(recognizer: UIPanGestureRecognizer) {
        
        self.currentTouchLocation = recognizer.locationInView(recognizer.view?.superview)
        
        // If (no filter shown and the touch location is on the TextField) or if touch is in textfield
        if (((((self.slides[previousIndex()].maskSize?.width)! + (self.slides[nextIndex()].maskSize?.width)!) == 0) && (self.textField.containsTouch(self.currentTouchLocation))) || (self.textField.touched == true))
        {
            // Touch is now ended, so nothing happens
            if ((recognizer.state == .Ended) || (recognizer.state == .Cancelled) || (recognizer.state == .Failed))
            {
                self.textField.touched = false
            }
                // Move the textfield to the finger's position
            else
            {
                self.textField.touched = true
                self.textField.setLocation(self.currentTouchLocation)
            }
        }
            // If a mask is shawn
        else
        {
            // Update mask position
            updateMaskFilter()
            
            // If touch is ended,
            if ((recognizer.state == .Ended) || (recognizer.state == .Cancelled) || (recognizer.state == .Failed))
            {
                let velocity = recognizer.velocityInView(recognizer.view?.superview)
                
                // If a swipe is detected
                if(velocity.x >= swipeThreshold) {
                    // Swipe to the right
                    touchesEndedWithSwipe(true)
                }
                else if (velocity.x <= -swipeThreshold) {
                    // Swipe to the left
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
