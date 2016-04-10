//
//  T_CameraHelper.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 07/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import UIKit

class T_CameraHelper {
    
    static func screenShot(view: UIView) -> UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}