//
//  T_SliderImageView.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 05/05/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import MBProgressHUD

class T_SliderImageView: UIImageView {
    // MARK: Properties
    var post : T_Post? {
        didSet {
            // free memory of image stored with post that is no longer displayed
            if let oldValue = oldValue where oldValue != post {
                oldValue.image.value = nil
            }
            
            if let post = post {
                post.image.bindTo(self.bnd_image)
                
                self.bnd_image.observe { image in
                    if image != nil {
                        self.unfreezeUI()
                    }
                }
            }
        }
    }
    
    var progressHUD:MBProgressHUD?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        freezeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    func freezeUI() {
        progressHUD = MBProgressHUD.showHUDAddedTo(self, animated: true)
        progressHUD?.mode = .Indeterminate
    }
    
    func unfreezeUI() {
        progressHUD?.hide(true)
    }
}
