//
//  CustomOverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "Like_photo"
private let overlayLeftImageName = "Dislike_photo"

class T_KolodaBanner: OverlayView {
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
    
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
    
        return imageView
    }()

    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .Left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .Right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
        }
    }
}