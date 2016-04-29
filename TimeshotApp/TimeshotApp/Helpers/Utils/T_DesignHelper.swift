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
    static let orangeDegrade = UIColor.init(colorLiteralRed: 239.0/255.0, green: 127.0/255.0, blue: 94.0/255.0, alpha: 1.0).CGColor
    static let rougeDegrade = UIColor.init(colorLiteralRed: 227.0/255.0, green: 80.0/255.0, blue: 104.0/255.0, alpha: 1.0).CGColor
    static let screenSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    static let startPoint:CGFloat = 0.2
    static let endPoint:CGFloat = 0.8

    // MARK: Methods
    static func colorNavBar(navbar: UINavigationBar){
        let layer = CAGradientLayer()
        layer.frame = navbar.bounds
        layer.frame.size.height += 20

        layer.colors = [rougeDegrade,orangeDegrade]
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
        let scale = screenSize.width/gradient.frame.width
        
        gradient.colors = [rougeDegrade,orangeDegrade]
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
        
        layer.colors = [rougeDegrade,orangeDegrade]
        layer.startPoint = CGPointMake(0.2, 0.0)
        layer.endPoint = CGPointMake(0.8, 0.0)
        
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        segmentedControl.setBackgroundImage(image, forState: .Normal, barMetrics: UIBarMetrics.Default)
    }
    
    static func flipH(im:UIImage)->UIImage {
        var newOrient:UIImageOrientation
        switch im.imageOrientation {
        case .Up:
            newOrient = .UpMirrored
        case .UpMirrored:
            newOrient = .Up
        case .Down:
            newOrient = .DownMirrored
        case .DownMirrored:
            newOrient = .Down
        case .Left:
            newOrient = .RightMirrored
        case .LeftMirrored:
            newOrient = .Right
        case .Right:
            newOrient = .LeftMirrored
        case .RightMirrored:
            newOrient = .Left
        }
        return UIImage(CGImage: im.CGImage!, scale: im.scale, orientation: newOrient)
    }
    
    static func makeRoundedImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
    }
    
}
