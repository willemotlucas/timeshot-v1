//
//  T_ParseUserHelper.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 07/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse

class T_ParseUserHelper {
    
    static func fileFromImage(image: UIImage) -> PFFile {
        return PFFile(data: UIImageJPEGRepresentation(image, 1.0)!)!
    }
    
    static func getUserFromObjects(objects: [PFObject]?) -> T_User? {
        if (objects?.count == 1) {
            return objects![0] as? T_User
        }
        else {
            return nil
        }
    }
    
    static func queryUserPinned(withCompletion: (currentUser: T_User?) -> ()) {
        
        let query = T_User.query()
        query!.fromLocalDatastore()
        query!.fromPinWithName("currentUser")
        query!.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if (error == nil)
            {
                withCompletion(currentUser: getUserFromObjects(objects))
            }
            else
            {
                print("error to find User locally in background")
                withCompletion(currentUser: nil)
            }
        }
        
    }
}