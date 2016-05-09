//
//  T_LocalFileManager.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 09/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

 class T_LocalFileManager {
    
    static func generateNameFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.SSSSSS"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    static func savePicture(image: UIImage, withName name: String) {
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fileURL = documentsURL.URLByAppendingPathComponent("\(name).png")
        if let pngImageData = UIImagePNGRepresentation(image) {
            pngImageData.writeToURL(fileURL, atomically: false)
        }
    }
    
    static func deletePictureAtPath(imagePath: String) {
        if (NSFileManager.defaultManager().fileExistsAtPath(imagePath)) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(imagePath)
//                print("old image has been removed")
            } catch {
                print("an error during a removing")
            }
        }
    }
    
    static func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    static func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    static func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            print("missing image at: \(path)")
        }
        else {
//            print("Loading image from path: \(path)")
        }
        return image
    }

    
}