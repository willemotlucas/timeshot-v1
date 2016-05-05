//
//  T_AlertHelper.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 01/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AlertHelper {
    static func alert(title : String, errors : [String], viewController : UIViewController) {
        let errorsString = errors.joinWithSeparator("\n")
        let buttonMessage = NSLocalizedString("Ok", comment: "")
        
        let alert = UIAlertController(title: title, message: errorsString, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.Default, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}