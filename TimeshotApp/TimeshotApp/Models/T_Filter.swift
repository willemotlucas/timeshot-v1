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
    init(frame: CGRect, named: String) {
        super.init(frame: frame)
        
        self.maskSize = frame.size
        self.image = UIImage(named: named)
    }
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        self.maskSize = frame.size
        self.contentMode = .ScaleAspectFill
        self.image = image
    }
    
    deinit
    {
        print("deinit filter")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Tools methods
    func mask(viewToMask: UIView, maskRect: CGRect) {
        let maskLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, maskRect)
        maskLayer.path = path
        viewToMask.layer.mask = maskLayer;
    }
    
    
    //MARK: Filter's mask update
    func animate(animation: String) -> Bool
    {
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
    
    func leftSideFilterUpdate(width: CGFloat)
    {
        self.maskSize?.width = width
        mask(self, maskRect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: abs(width), height: self.frame.size.height))
    }
    
    func rightSideFilterUpdate(width: CGFloat)
    {
        self.maskSize?.width = width
        mask(self, maskRect: CGRect(x: self.frame.origin.x + self.frame.size.width - abs(width), y: self.frame.origin.y, width: abs(width), height: self.frame.size.height))
    }
    
    //MARK: Filter's mask initilization
    func mainFilterInit()
    {
        mask(self, maskRect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height))
        self.maskSize?.width = self.frame.size.width
    }
    
    func leftSideFilterInit()
    {
        mask(self, maskRect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 0, height: self.frame.size.height))
        self.maskSize?.width = 0
    }
    
    func rightSideFilterInit()
    {
        mask(self, maskRect: CGRect(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y, width: 0, height: self.frame.size.height))
        self.maskSize?.width = 0
    }
    
}