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
}