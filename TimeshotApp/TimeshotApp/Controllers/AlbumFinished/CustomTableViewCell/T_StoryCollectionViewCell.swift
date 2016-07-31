//
//  StoryCollectionViewCell.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_StoryCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storyLabel: UILabel!
    
    var post : T_Post? {
        didSet {
            //free memory of image stored with post that is no longer displayed
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.bindTo(imageView.bnd_image).dispose()
            }
            
            if let post = post {
                //imageView.bnd_image.value = post.image.value
                post.image.bindTo(imageView.bnd_image)
            }
        }
    }
    
    // MARK: Initialisation
    func initCellWithMetaData(post: T_Post?, isLiveAlbum: Bool){
        if(isLiveAlbum) {
            // On ne met que notre photo par defaut
            imageView.bnd_image.value = UIImage(named: "endAlbum")
            
            storyLabel.text = NSLocalizedString("Ready to discover your story !", comment: "")
        } else {
            // on met la story dans l'ordre
            self.post = post
            storyLabel.text = NSLocalizedString("Remember the best moment of your album !", comment: "")
            
            if  imageView.image == nil {
                imageView.bnd_image.value = UIImage(named: "EmptyView")
            }
        }
        
    }
}
