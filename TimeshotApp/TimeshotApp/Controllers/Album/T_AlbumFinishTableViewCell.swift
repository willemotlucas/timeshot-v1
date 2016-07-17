//
//  T_AlbumFinishTableViewCell.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 19/03/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond
import AFDateHelper

class T_AlbumFinishTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var coverAlbum: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleAlbumLabel: UILabel!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var backgroundTitle: UIView!
    @IBOutlet weak var backgroundTitleFinished: UIView!
    
    var timerLive : NSTimer?
    var timerDuration : Int = 0
    
    var album: T_Album? {
        didSet {
            // we check to see if the value is nil
            if let album = album {
                // bind the image of the album to the 'coverAlbum' view
                album.coverImage.bindTo(coverAlbum.bnd_image)
            }
        }
    }
    
    // MARK: Initialisation
    func initCellWithMetaData(date: NSDate, title :String){
        T_DesignHelper.colorUIView(backgroundTitle)
        backgroundTitle.alpha = 0.75
        
        backgroundTitleFinished.backgroundColor = UIColor.blackColor()
        backgroundTitleFinished.alpha = 0.65
        
        dateLabel.text = String(date.day())+"\n"+date.monthToString()
        titleAlbumLabel.text = title
        
        if(T_Album.isLiveAlbumAssociatedToUser(album)) {
            backgroundTitleFinished.hidden = true
            backgroundTitle.hidden = false
            liveLabel.hidden = false
            
        } else {
            backgroundTitleFinished.hidden = false
            backgroundTitle.hidden = true
            liveLabel.hidden = true
        }
        
        self.selectionStyle = .None
    }
    
    
    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
