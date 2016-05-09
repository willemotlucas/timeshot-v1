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
        guard let currentUser = PFUser.currentUser() as? T_User where currentUser.liveAlbum != nil else { return }
        
        // S'il y a au moins un post à envoyer
        if let post = self.getHead() {
            
            // Si un envoi est djéà en cours, on reporte l'envoi
            if(self.isUploading == true) { return }
            
            self.isUploading = true
            T_NetworkStatus.sharedInstance.updateLabelText(T_NetworkStatus.status.Uploading)

            self.postCreationTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
            }

            let fileName = T_LocalFileManager.generateNameFromDate(post.createdAtDate)
            let imagePath = T_LocalFileManager.fileInDocumentsDirectory("\(fileName).png")
            let imageFromLocalStorage = T_LocalFileManager.loadImageFromPath(imagePath)
            
            // Si le data de l'image est dispo
            if (post.photo.dataAvailable == true) {
                var imageSize: Int
                try! imageSize = post.photo.getData().length

                // Le post est trop léger = l'image n'est plus dans le cache : on load localement la photo
                if(imageSize < 100) {
                    post.addPictureToPost(imageFromLocalStorage!)
                }
            }

            post.saveInBackgroundWithBlock {
                (success, error) -> Void in
                if success {
                    
                    print("Post uploaded successfully")
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
                    print("Pas de réseau (ou autre erreur), veuillez réessayer") // , error)
                    
                    T_NetworkStatus.sharedInstance.updateLabelText(T_NetworkStatus.status.Error)

                    self.isUploading = false
                    UIApplication.sharedApplication().endBackgroundTask(self.postCreationTask!)
                }
            }
        }
        else {
            T_NetworkStatus.sharedInstance.updateLabelText(T_NetworkStatus.status.ShowAlbumTitle)
        }
        
    }
}







