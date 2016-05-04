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
            if let post = post {
                post.image.bindTo(self.bnd_image)
            }
        }
    }
}
