//
//  T_MultiAlbumStatus.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 22/06/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_MultiAlbumStatus: UIView {
    
    static let sharedInstance = T_MultiAlbumStatus()
    private var albumTitle: UILabel!
    private var albumTitleBackground: UIView!
    private var albumImage: UIImageView!
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: T_DesignHelper.screenSize.width, height: 90))
        
        self.hidden = true
        self.userInteractionEnabled = true
        
        self.albumTitle = UILabel(frame: CGRect(x: T_DesignHelper.screenSize.width/2, y: 16, width: 0, height: 24))
        self.albumTitleBackground = UIView(frame: CGRect(x: T_DesignHelper.screenSize.width/2, y: 16, width: 0, height: 24))
        self.albumImage = UIImageView(frame: CGRect(x: 0, y: 18, width: 24, height: 20))
        self.albumImage.image = UIImage(named: "Group")
        
        self.albumTitle.layer.zPosition = 2
        self.albumTitleBackground.layer.zPosition = 1
        self.albumTitle.backgroundColor = UIColor.clearColor()
        self.albumTitleBackground.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        
        self.albumTitleBackground.layer.cornerRadius = 12
        self.albumTitle.font = UIFont.systemFontOfSize(15)
        self.albumTitle.textColor = UIColor.whiteColor()
        self.albumTitleBackground.layer.masksToBounds = true
        self.albumImage.layer.zPosition = 11
        
        self.addSubview(self.albumTitle)
        self.addSubview(self.albumTitleBackground)
        self.addSubview(self.albumImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabelText(text:String = "") {
        
        var finalText:String
        finalText = "   \(text.trunc(25))"
        self.albumImage.hidden = false
        let textSize = finalText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15.0)])
        self.albumTitle.frame.size.width = 40 + textSize.width
        self.albumTitleBackground.frame.size.width = textSize.width + 40
        self.albumTitle.textAlignment = .Left
        self.albumImage.contentMode = .ScaleAspectFit
        self.albumImage.frame.origin = CGPoint(x: T_DesignHelper.screenSize.width/2 + self.albumTitle.frame.size.width/2 - 33, y: self.albumImage.frame.origin.y)
        
        self.albumTitle.frame.origin = CGPoint(x: T_DesignHelper.screenSize.width/2 - self.albumTitle.frame.size.width/2, y: self.albumTitle.frame.origin.y)
        self.albumTitleBackground.frame.origin = CGPoint(x: T_DesignHelper.screenSize.width/2 - self.albumTitle.frame.size.width/2, y: self.albumTitle.frame.origin.y)
        self.albumTitle.text = finalText
        
        // Gradient
        self.show()
    }
    
    func hide() {
        self.hidden = true
    }
    
    func show() {
        self.hidden = false
    }
    
    func pressed() {
        T_CameraViewController.instance.modalView.updateContent()
        
        UIView.animateWithDuration(0.15, animations: {
            T_CameraViewController.instance.modalView.frame.origin.y = 0
        })
        
    }
}


