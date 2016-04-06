//
//  T_Filter.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 24/03/2016.
//  Copyright © 2016 Timeshot. All righT_ reserved.
//

import UIKit

class T_Filter: UIImageView {
    
    //MARK: Properties
    var maskSize:CGSize?
    
    //MARK: Constructors
    // Init with an image name
    init(frame: CGRect, named: String) {
        super.init(frame: frame)
        
        self.maskSize = frame.size
        self.image = UIImage(named: named)
    }
    
    // Init with a UIImage
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        self.maskSize = frame.size
        self.contentMode = .ScaleAspectFill
        self.image = image
    }
    
    deinit {
//        print("deinit filter")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Tools methods
    // Apply a mask to a certain CGRect
    func mask(viewToMask: UIView, maskRect: CGRect) {
        let maskLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, maskRect)
        maskLayer.path = path
        viewToMask.layer.mask = maskLayer;
    }
    
    //MARK: Filter's mask update
    // Animation to update filters masks
    func animate(animation: String) -> Bool {
        switch (animation) {
        case "animateLeftFilterToRight":
            
            if (self.maskSize?.width < self.frame.width)
            {
                leftSideFilterUpdate((self.maskSize?.width)! + 1)
                return true
            }
            else
            {
                return false
            }
            
        case "leftFilterGoBackLeft":
            
            if (self.maskSize?.width > 0)
            {
                leftSideFilterUpdate((self.maskSize?.width)! - 1)
                return true
            }
            else
            {
                return false
            }
            
        case "animateRightFilterToLeft":
            if (abs((self.maskSize?.width)!) < self.frame.width)
            {
                rightSideFilterUpdate((self.maskSize?.width)! - 1)
                return true
            }
            else
            {
                return false
            }
            
        case "rightFilterGoBackRight":
            if (((self.maskSize?.width)!) < 0)
            {
                rightSideFilterUpdate((self.maskSize?.width)! + 1)
                return true
            }
            else
            {
                return false
            }
            
        default:
            return false
        }
    }
    
    // Change the width of a left side Filter
    func leftSideFilterUpdate(width: CGFloat) {
        self.maskSize?.width = width
        mask(self, maskRect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: abs(width), height: self.frame.size.height))
    }
    
    // Change the width of a right side Filter
    func rightSideFilterUpdate(width: CGFloat) {
        self.maskSize?.width = width
        mask(self, maskRect: CGRect(x: self.frame.origin.x + self.frame.size.width - abs(width), y: self.frame.origin.y, width: abs(width), height: self.frame.size.height))
    }
    
    //MARK: Filter's mask initilization
    // Full screen visible filter
    func mainFilterInit() {
        mask(self, maskRect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height))
        self.maskSize?.width = self.frame.size.width
    }
    
    // Hidden left filter
    func leftSideFilterInit() {
        mask(self, maskRect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 0, height: self.frame.size.height))
        self.maskSize?.width = 0
    }
    
    // Hidden right filter
    func rightSideFilterInit() {
        mask(self, maskRect: CGRect(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y, width: 0, height: self.frame.size.height))
        self.maskSize?.width = 0
    }
    
}