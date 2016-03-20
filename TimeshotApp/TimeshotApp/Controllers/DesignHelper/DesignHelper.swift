//
//  DesignHelper.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 20/03/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import UIKit

class T_DesignHelper {
    static func colorNavBar(navbar: UINavigationController){
        let orangeFonce = UIColor.init(colorLiteralRed: 243.0/255.0, green: 199.0/255.0, blue: 161.0/255.0, alpha: 1.0).CGColor
        let orangeClair = UIColor.init(colorLiteralRed: 232.0/255.0, green: 121.0/255.0, blue: 117.0/255.0, alpha: 1.0).CGColor
        
        let layer = CAGradientLayer()
        layer.frame = navbar.navigationBar.bounds
        layer.frame.size.height += 20
        
        
        
        
        layer.colors = [orangeFonce,orangeClair]
        layer.startPoint = CGPointMake(0.0, 0.0)
        layer.endPoint = CGPointMake(1.0, 0.0)
        
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navbar.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        navbar.navigationBar.translucent = false
    }
}


