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
            if let post = post {
                post.image.bindTo(imageView.bnd_image)
            }
        }
    }
}
