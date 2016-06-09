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
    
    static func alertOK(title : String, message : String, viewController : UIViewController) {
        let buttonMessage = NSLocalizedString("Ok", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.Default, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func alert2Actions(title: String, message: String, button1message: String, button2message: String, viewController: UIViewController, completion: (UIAlertAction)->Void){
        let button1 = NSLocalizedString(button1message, comment: "")
        let button2 = NSLocalizedString(button2message, comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.Default, handler: completion))
        alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Default, handler: completion))
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}