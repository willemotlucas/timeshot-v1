//
//  PhotoCollectionViewCell.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_PhotoCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    
    var post : T_Post? {
        didSet {
            //free memory of image stored with post that is no longer displayed
            if let oldValue = oldValue where oldValue != post {
                print("==============")
                print(oldValue.objectId)
                print(post?.objectId)
                print("==============")
                oldValue.image.value = nil
            }
            
            if let post = post {
                imageView.image = nil
                post.image.bindTo(imageView.bnd_image)
            } 
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
