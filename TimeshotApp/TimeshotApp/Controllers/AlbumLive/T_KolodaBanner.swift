//
//  CustomOverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "overlay_like"
private let overlayLeftImageName = "overlay_skip"

class T_KolodaBanner: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    @IBOutlet lazy var overlayView: UIView! = {
        [unowned self] in
        
        var view = UIView(frame: self.bounds)
        self.addSubview(view)
        
        return view
        }()
    
    override var overlayStrength: CGFloat {
        didSet {
            self.alpha = 1.0
        }
    }
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            /*case .Left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .Right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)*/
            default:
                overlayImageView.image = nil
            }
            
        }
    }
    
}