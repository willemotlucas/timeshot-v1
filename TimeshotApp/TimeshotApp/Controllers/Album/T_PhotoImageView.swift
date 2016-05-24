//
//  T_PhotoImageView.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 16/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_PhotoImageView: UIImageView {
    // MARK: Properties
    var post : T_Post? {
        didSet {
            // free memory of image stored with post that is no longer displayed
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                post.image.bindTo(self.bnd_image)
            }
        }
    }
}
