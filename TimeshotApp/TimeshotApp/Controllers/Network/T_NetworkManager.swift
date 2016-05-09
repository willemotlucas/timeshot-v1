//
//  T_NetworkManager.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 08/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse

class T_NetworkManager {
    
    
    private var queue:[T_Post] = []
    static let sharedInstance = T_NetworkManager()
    private init() {
    
        T_ParsePostHelper.postsNotUploaded{
            (result: [PFObject]?, error: NSError?) -> Void in
            
            print("init with \(self.queue.count) items")

            print("\(result?.count)")
            let posts = result as? [T_Post] ?? []
            for post in posts {
                print("\(post.createdAtDate.toString())")
                post.photo = PFFile(data: NSData())!
                self.queue.append(post)
            }
            print("now with \(self.queue.count) items pinned")
        }
        
    }
    private var isUploading = false
    private var postCreationTask: UIBackgroundTaskIdentifier?
    func enqueue(post: T_Post, image: UIImage) {
        self.queue.append(post)
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.SSSSSS"
        let dateString = dateFormatter.stringFromDate(post.createdAtDate)

        let fileURL = documentsURL.URLByAppendingPathComponent("\(dateString).png")
            if let pngImageData = UIImagePNGRepresentation(image) {
                pngImageData.writeToURL(fileURL, atomically: false)
        }
        print(fileURL)
        
        post.pinInBackgroundWithName(post.createdAtDate.toString())

    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        print("Loading from disk")
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            print("missing image at: \(path)")
        }
        else {
            print("Loading image from path: \(path)")
        }
        return image
    }
    
    func count() -> Int {
        return queue.count
    }
    
    func dequeue() -> T_Post? {
        if(queue.count > 0) {
            let post = queue[0]
            queue.removeFirst()
            return post
        }
        else {
            return nil
        }
    }
    
    func getHead() -> T_Post? {
        if(queue.count > 0) {
            let post = queue[0]
            return post
        }
        else {
            return nil
        }
    }
    
    func synced(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    func uploadPost(post: T_Post, image: UIImage) {
        enqueue(post, image: image)
        upload()
    }
    
    func upload() {
        guard let currentUser = PFUser.currentUser() as? T_User where currentUser.liveAlbum != nil else {
            print("Not connected, cannot create the post")
            return
        }
        
        
        if let post = self.getHead() {
            print("a post wants to be sent")
            
            if(self.isUploading == true) {
                print("send canceled");
                post.pinned = true
                return
            }
            
            self.isUploading = true
            print("a post is going to be sent")
            self.postCreationTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
            }

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.SSSSSS"
            let dateString = dateFormatter.stringFromDate(post.createdAtDate)
            
            let imagePath = fileInDocumentsDirectory("\(dateString).png")
            let image2 = loadImageFromPath(imagePath)

            
                print("-------")
                print("Loading from disk")
                post.addPictureToPost(image2!)
                print("-------")

            
            post.saveInBackgroundWithBlock {
                (success, error) -> Void in
                if success {
                    let post = self.dequeue()
                    post!.unpinInBackgroundWithName((post?.createdAtDate.toString())!)
                    print("Post upload")
                    self.isUploading = false
                    
                    if (NSFileManager.defaultManager().fileExistsAtPath(imagePath)) {
                        do {
                            try NSFileManager.defaultManager().removeItemAtPath(imagePath)
                            print("old image has been removed")
                        } catch {
                            print("an error during a removing")
                        }
                    }

                    
                    UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
                    self.upload()
                } else {
                    print("An error occured : %@", error)
                    let post = self.getHead()
                    post!.pinned = true
                    self.isUploading = false
                    UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
                    return
                }
            }

        }
    }
}







