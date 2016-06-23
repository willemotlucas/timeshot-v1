//
//  T_NetworkStatus.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 09/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// background du tableview dans l'ajout d'amis
// les filtres
// ajouter un action sur le screen quand album créé ou raté
//

class T_NetworkStatus: UIView {
    
    static let sharedInstance = T_NetworkStatus()
    private var albumTitle: UILabel!
    private var albumTitleBackground: UIView!
    private var _albumTitle: String = ""
    private var albumImage: UIImageView!
    private var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 24, height: 20), type: .BallPulse, color: UIColor.whiteColor())
    
    enum status {
        case ShowAlbumTitle
        case Error
        case Uploading
    }
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: T_DesignHelper.screenSize.width, height: 90))
        
        self.hidden = true
        self.activityIndicatorView.hidden = true
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
        self.activityIndicatorView.layer.zPosition = 11
        
        self.addSubview(self.albumTitle)
        self.addSubview(self.albumTitleBackground)
        self.addSubview(self.albumImage)
        self.addSubview(self.activityIndicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabelText(mode: status, withText text:String = "") {
        
        var finalMode = mode
        
        if (text != "" && mode == .ShowAlbumTitle) { self._albumTitle = text }
        
        if(T_NetworkManager.sharedInstance.count() > 0 && T_NetworkManager.sharedInstance.isUploading == false) {
            finalMode = .Error
        }
        else if (T_NetworkManager.sharedInstance.count() > 0 && T_NetworkManager.sharedInstance.isUploading == true) {
            finalMode = .Uploading
        }
        
        var finalText:String
        switch finalMode {
        case .ShowAlbumTitle:
            finalText = "   \(self._albumTitle.trunc(25))"
            self.albumImage.hidden = false
            self.activityIndicatorView.hidden = true
            let textSize = finalText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15.0)])
            self.albumTitle.frame.size.width = 40 + textSize.width
            self.albumTitleBackground.frame.size.width = textSize.width + 40
            self.albumTitle.textAlignment = .Left
            self.albumImage.contentMode = .ScaleAspectFit
            self.albumImage.frame.origin = CGPoint(x: T_DesignHelper.screenSize.width/2 + self.albumTitle.frame.size.width/2 - 33, y: self.albumImage.frame.origin.y)
            self.activityIndicatorView.stopAnimation()
            T_CameraViewController.instance.modalView.cleanErrors()
            
        case .Error:
            finalText = "Upload failed (\(T_NetworkManager.sharedInstance.count()))"
            self.albumImage.hidden = true
            self.activityIndicatorView.hidden = true
            let textSize = finalText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15.0)])
            self.albumTitle.frame.size.width = textSize.width + 40
            self.albumTitleBackground.frame.size.width = textSize.width + 40
            self.albumTitle.textAlignment = .Center
            self.activityIndicatorView.stopAnimation()
            T_CameraViewController.instance.modalView.showErrors(T_NetworkManager.sharedInstance.count())
            
        case .Uploading:
            finalText = "   Uploading"
            self.albumImage.hidden = true
            let textSize = finalText.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15.0)])
            self.albumTitle.frame.size.width = textSize.width + 40
            self.albumTitleBackground.frame.size.width = textSize.width + 40
            self.albumTitle.textAlignment = .Left
            self.activityIndicatorView.hidden = false
            self.activityIndicatorView.frame.origin = CGPoint(x: T_DesignHelper.screenSize.width/2 + self.albumTitle.frame.size.width/2 - 33, y: self.albumTitle.frame.origin.y + 3)
            self.activityIndicatorView.startAnimation()
        }
        
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
        
        //        if(T_NetworkManager.sharedInstance.count() > 0 && T_NetworkManager.sharedInstance.isUploading == false) {
        //            T_NetworkManager.sharedInstance.upload()
        //        }
    }
}
