//
//  T_Modale.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 22/06/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse

class T_ModalView: UIView {
    
    var title = UILabel(frame: CGRect(x: 0, y: 5, width: T_DesignHelper.screenSize.width, height: 40))
    var errorButton = UIButton(frame: CGRect(x: T_DesignHelper.screenSize.width/5, y: 52, width: 3/5*T_DesignHelper.screenSize.width, height: 40))
    
    var quitButton = UIButton(frame: CGRect(x: 10, y: 10, width: 34, height: 34))
    var scrollView = UIScrollView(frame: CGRect(x: T_DesignHelper.screenSize.width/8, y: 100, width: 6*T_DesignHelper.screenSize.width/8, height: 0))
    var albumButtons:[T_AlbumButton] = []
    var label = UILabel(frame: CGRect(origin: CGPoint(x: T_DesignHelper.screenSize.width/5, y: T_DesignHelper.screenSize.height - 140), size: CGSize(width: 3*T_DesignHelper.screenSize.width/5, height: 60)))
    var createAlbumButton = UIButton(frame: CGRect(x: T_DesignHelper.screenSize.width/5, y: T_DesignHelper.screenSize.height - 65, width: 3/5*T_DesignHelper.screenSize.width, height: 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.zPosition = 10
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        self.addSubview(self.scrollView)
        scrollView.frame.size.height = 320.0
        
        title.text = "Live albums"
        title.textAlignment = .Center
        title.font = UIFont(name: title.font.fontName, size: 24)
        title.textColor = UIColor.whiteColor()
        
        quitButton.setImage(UIImage(named: "Cancel"), forState: .Normal)
        quitButton.addTarget(self, action: #selector(T_ModalView.quitButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        guard let currentUser = PFUser.currentUser() as? T_User else { return }
        var albums = currentUser.albums
        scrollView.contentSize.height = CGFloat(80*albums.count)
        
        for (index, album) in albums.enumerate() {
            
            let button = T_AlbumButton(text: album.title)
            button.frame.origin.y = CGFloat(index)*80
            albumButtons.append(button)
            button.addTarget(self, action: #selector(T_ModalView.albumButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.scrollView.addSubview(button)
        }
        
        self.label.text = "Choose the album you want to join or"
        self.label.textAlignment = .Center
        if #available(iOS 9.0, *) {
            self.label.allowsDefaultTighteningForTruncation = false
        }
        self.label.baselineAdjustment = .AlignCenters
        self.label.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        self.label.numberOfLines = 0
        self.label.font = UIFont(name: title.font.fontName, size: 18)
        self.label.textColor = UIColor.whiteColor()
        
        self.createAlbumButton.setTitle("Create album", forState: .Normal)
        self.createAlbumButton.layer.cornerRadius = self.createAlbumButton.frame.size.height/2
        self.createAlbumButton.backgroundColor = UIColor.whiteColor()
        self.createAlbumButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        self.createAlbumButton.addTarget(self, action: #selector(T_ModalView.createAlbum), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.errorButton.setTitle("Upload failed. Try again!", forState: .Normal)
        self.errorButton.layer.cornerRadius = self.createAlbumButton.frame.size.height/2
        self.errorButton.backgroundColor = UIColor.whiteColor()
        self.errorButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        self.errorButton.addTarget(self, action: #selector(T_ModalView.errorButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.errorButton.hidden = true
        
        self.addSubview(errorButton)
        self.addSubview(createAlbumButton)
        self.addSubview(label)
        self.addSubview(title)
        self.addSubview(quitButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func quitButtonPressed() {
        UIView.animateWithDuration(0.15, animations: {
            self.frame.origin.y = -T_DesignHelper.screenSize.height
        })
    }
    
    func updateContent() {
        
        
        guard let currentUser = PFUser.currentUser() as? T_User else { return }
        let albums = currentUser.albums
        scrollView.contentSize.height = CGFloat(80*albums.count)
        
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        albumButtons.removeAll()
        
        for (index, album) in albums.enumerate() {
            
            let button = T_AlbumButton(text: album.title)
            button.frame.origin.y = CGFloat(index)*80
            albumButtons.append(button)
            
            if (album == currentUser.liveAlbum) {
                button.setHighlightedStyle()
            }
            
            button.addTarget(self, action: #selector(T_ModalView.albumButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.scrollView.addSubview(button)
        }
    }
    
    func errorButtonPressed() {
        T_NetworkManager.sharedInstance.upload()
        self.quitButtonPressed()
    }
    
    func createAlbum() {
        let controller = T_CameraViewController.instance
        controller.createAlbumInit()
        controller.showQuitButton()
        self.quitButtonPressed()
    }
    
    func albumButtonPressed(sender: UIButton!) {
        for (index, album) in albumButtons.enumerate() {
            if (sender == album) {
                album.setHighlightedStyle()
                guard let currentUser = PFUser.currentUser() as? T_User else { return }
                currentUser.liveAlbum = currentUser.albums[index]
                T_CameraViewController.instance.updateAlbumStatus()
                quitButtonPressed()
            }
            else {
                album.resetStyle()
            }
        }
    }
    
    func showErrors(numberError:Int) {
        errorButton.hidden = false
        errorButton.setTitle("Upload failed ! (\(numberError))", forState: .Normal)
    }
    
    func cleanErrors() {
        errorButton.hidden = true
    }
    
}
