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
    
}
