//
//  T_AlbumLiveTableViewCell.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 19/03/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond
import AFDateHelper

class T_AlbumLiveTableViewCell: UITableViewCell {
    // MARK : Properties
    @IBOutlet weak var coverAlbum: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleAlbumLabel: UILabel!
    @IBOutlet weak var backgroundTitle: UIView!
    
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
        titleAlbumLabel.text = title
        T_DesignHelper.colorUIView(backgroundTitle)
        backgroundTitle.alpha = 0.75
        
        timerDuration = Int(T_Album.getRemainingDuration(album!.createdAt!, duration: album!.duration))
        timerLiveAction()
        self.timerLive = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(T_AlbumLiveTableViewCell.timerLiveAction), userInfo: nil, repeats: true)
        
    }
    
    // MARK: Actions
    func timerLiveAction() {
        if timerDuration >= 1 {
            timerDuration -= 1
            
            let hour = timerDuration / 3600
            let min = (timerDuration % 3600) / 60
            let second = (timerDuration % 3600) % 60
            
            var value = ""
            
            if hour > 0 {
                value += String(hour)+":"
            }
            
            if min > 0 {
                value += String(min)+":"
            }
            
            if second > 0 {
                value += String(second)
            }
            
            dateLabel.text = value
        } else {
            timerLive?.invalidate()
        }
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
