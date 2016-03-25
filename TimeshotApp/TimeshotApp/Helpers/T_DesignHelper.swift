//
//  DesignHelper.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 22/03/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import UIKit

class T_DesignHelper {
    // MARK: Properties
    static let orangeClair = UIColor.init(colorLiteralRed: 243.0/255.0, green: 199.0/255.0, blue: 161.0/255.0, alpha: 1.0).CGColor
    static let orangeFonce = UIColor.init(colorLiteralRed: 232.0/255.0, green: 121.0/255.0, blue: 117.0/255.0, alpha: 1.0).CGColor
    static let screenWidth = UIScreen.mainScreen().bounds.width
    static let startPoint:CGFloat = 0.2
    static let endPoint:CGFloat = 0.8
    // MARK: Methods
    static func colorNavBar(navbar: UINavigationBar){
        let layer = CAGradientLayer()
        layer.frame = navbar.bounds
        layer.frame.size.height += 20

        layer.colors = [orangeFonce,orangeClair]
        layer.startPoint = CGPointMake(startPoint, 0.0)
        layer.endPoint = CGPointMake(endPoint, 0.0)
        
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navbar.setBackgroundImage(image, forBarPosition: .Any, barMetrics: .Default)
        navbar.shadowImage = UIImage()
        navbar.translucent = false
    }
    
    static func colorUIView(view: UIView){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let scale = screenWidth/gradient.frame.width
        
        gradient.colors = [orangeFonce,orangeClair]
        gradient.startPoint = CGPointMake(startPoint * scale, 0.0)
        gradient.endPoint = CGPointMake(endPoint * scale, 0.0)
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.renderInContext(UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()
        
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    static func colorSegmentedControl(segmentedControl: UISegmentedControl){
        let layer = CAGradientLayer()
        layer.frame = segmentedControl.bounds
        
        layer.colors = [orangeFonce,orangeClair]
        layer.startPoint = CGPointMake(0.2, 0.0)
        layer.endPoint = CGPointMake(0.8, 0.0)
        
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        segmentedControl.setBackgroundImage(image, forState: .Normal, barMetrics: UIBarMetrics.Default)
    }
}
