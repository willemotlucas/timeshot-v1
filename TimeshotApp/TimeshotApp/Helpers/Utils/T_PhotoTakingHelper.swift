//
//  T_PhotoTakingHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 15/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

// Specifies that all PhotoTakingHelperCallback methods has this signature
typealias PhotoTakingHelperCallback = UIImage? -> Void

class T_PhotoTakingHelper: NSObject {
    
    // MARK: properties
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    // Constructor of the PhotoTakingHelper class which provides a view to display UIAlert and a callback method
    // to call when a photo is taken or selected
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback){
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    // Constructs the UIAlert which will be displayed to the user to select options to choose a photo
    func showPhotoSourceSelection(){
        // Constructs the UIAlert
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .ActionSheet)
        
        //Add actions to the UIAlert
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Pick a photo from library", comment: ""), style: .Default){
            (action) in
            // Callback function (closure) called when user selects photo from library
            self.showImagePickerController(.PhotoLibrary)
        }
        alertController.addAction(photoLibraryAction)
        
        // If the hardware camera is not available (because the app is running on simulator) we do nothing
        if(UIImagePickerController.isCameraDeviceAvailable(.Rear)){
            let cameraAction = UIAlertAction(title: NSLocalizedString("Take a photo with camera", comment: ""), style: .Default) {
                (action) in
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        
        // We use the reference to the viewController to display the UIAlert because only view controllers
        // can display other controllers
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Constructs and display the image picker which is a part of UIKit
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType){
        imagePickerController = UIImagePickerController()
        // Store the source type (camera or library)
        imagePickerController!.sourceType = sourceType
        // Set the delegate of imagePickerController to be able to detect when user chooses or takes a photo
        imagePickerController!.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
}

// Implement some protocols to detect when user chooses or takes a photo
extension T_PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Called when user selects or takes a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // Hide the imagePickerController
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        // Call the callback method of PhotoTakingHelper which is defined in TimelineViewController
        // because this is the class which instanciates PhotoTakingHelper
        callback(image)
    }
    
    // Called when user cancel the imagePickerController
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

