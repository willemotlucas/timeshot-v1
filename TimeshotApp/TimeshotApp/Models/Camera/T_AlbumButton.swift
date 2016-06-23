//
//  AlbumButton.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 22/06/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AlbumButton: UIButton {
    
    var gradiantLayer:CALayer? = nil
    
    init(text: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 6*T_DesignHelper.screenSize.width/8, height: 45))
        
        self.setTitle(text, forState: .Normal)
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetStyle() {
        if(gradiantLayer != nil) {
            self.layer.sublayers?.removeAtIndex(0)
            gradiantLayer = nil
            self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        }
    }
    
    func setHighlightedStyle() {
        if (gradiantLayer == nil) {
            self.alpha = 1
            self.backgroundColor = UIColor.clearColor()
            self.gradiantLayer = T_DesignHelper.createGradientLayer(CGRect(origin : CGPointZero, size: self.frame.size))
            self.gradiantLayer!.cornerRadius = self.frame.size.height/2
            self.layer.insertSublayer(gradiantLayer!, atIndex: 0)
        }
    }
}
