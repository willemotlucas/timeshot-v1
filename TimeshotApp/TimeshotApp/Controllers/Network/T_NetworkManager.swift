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

    private var queue:[T_Post] = []
    private let dispatchQueue = dispatch_queue_create("networkUploadQueue", DISPATCH_QUEUE_CONCURRENT)
    static let sharedInstance = T_NetworkManager()
    
    // Private back-up
    private var _isUploading = false
    // For public access
    var isUploading: Bool {
        get {
            var result = false
            dispatch_sync(dispatchQueue) {
                result = self._isUploading
            }
            return result
        }
        
        set {
            dispatch_barrier_async(dispatchQueue) {
                self._isUploading = newValue
            }
        }
    }
    
    private var postCreationTask: UIBackgroundTaskIdentifier?
    
    func enqueue(post: T_Post, image: UIImage) {
        self.queue.append(post)
        
        // Save locally
        let fileName = T_LocalFileManager.generateNameFromDate(post.createdAtDate)
        T_LocalFileManager.savePicture(image, withName: fileName)
        
        // Pin the post
        post.pinInBackgroundWithName(fileName)
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
    
    func uploadPost(post: T_Post, image: UIImage) {
        enqueue(post, image: image)
        upload()
    }
    
    func upload() {
        guard let currentUser = PFUser.currentUser() as? T_User where currentUser.liveAlbum != nil else {
            print("Not connected, cannot create the post")
            return
        }
        
        // S'il y a au moins un post à envoyer
        if let post = self.getHead() {
            print("a post wants to be sent")
            
            // Si un envoi est djéà en cours, on reporte l'envoi
            if(self.isUploading == true) {
                print("send delayed");
                // Post pinned car on devra charger l'image localement et remplacer le PFFile
                post.pinned = true
                return
            }
            
            self.isUploading = true
            print("a post is going to be sent")
            self.postCreationTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
            }

            let fileName = T_LocalFileManager.generateNameFromDate(post.createdAtDate)
            
            let imagePath = T_LocalFileManager.fileInDocumentsDirectory("\(fileName).png")
            let imageFromLocalStorage = T_LocalFileManager.loadImageFromPath(imagePath)

            if(post.pinned == true) {
                print("-------")
                print("Loading from disk")
                post.addPictureToPost(imageFromLocalStorage!)
                print("-------")
            }
            
            post.saveInBackgroundWithBlock {
                (success, error) -> Void in
                if success {
                    
                    print("Post upload")
                    // On le supprime de la file
                    let post = self.dequeue()
                    // On le unpin localement
                    let fileName = T_LocalFileManager.generateNameFromDate(post!.createdAtDate)
                    post!.unpinInBackgroundWithName(fileName)
                    // On supprime l'image du local storage
                    T_LocalFileManager.deletePictureAtPath(imagePath)
                    // On donne l'accès aux autres upload
                    self.isUploading = false
                    // Fin de la tache de fond pour l'upload
                    UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
                    
                    // On rappelle upload pour passer à l'élément suivant
                    self.upload()
                    
                } else {
                    print("An error occured : %@", error)
                    
                    // On indique que le post est pinned, dans le sens ou
                    let post = self.getHead()
                    
                    // Post pinned car on devra charger l'image localement et remplacer le PFFile
                    post!.pinned = true
                    self.isUploading = false
                    UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
                    return
                }
            }

        }
    }
}







