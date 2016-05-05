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
    private static let DEFAULT_BORDER_SIZE_BUTTON = CGFloat(0.5)

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
    static func addSubBorder(field : UITextField){
        let border = CALayer()
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: field.frame.size.height - DEFAULT_BORDER_SIZE_BUTTON, width:  field.frame.size.width, height: field.frame.size.height)
        
        border.borderWidth = DEFAULT_BORDER_SIZE_BUTTON
        field.layer.addSublayer(border)
        field.layer.masksToBounds = true
        
    }
    
    static func colorPlaceHolder(field : UITextField) {
        if let placeholder = field.placeholder {
            field.attributedPlaceholder  = NSAttributedString(string: placeholder,
                                                              attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        
    }
    
    static func colorBorderButton(button: UIButton){
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    static func addRoundBorder(button : UIButton) {
        button.layer.borderWidth = DEFAULT_BORDER_SIZE_BUTTON
        button.layer.cornerRadius = CGFloat(button.frame.size.height/2)
    }
    
    static func makeRoundedImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
    }
    
}
