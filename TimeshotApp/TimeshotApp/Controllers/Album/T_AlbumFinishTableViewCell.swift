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
    @IBOutlet weak var countdownLabel: UILabel!
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
            dateLabel.hidden = true
            backgroundTitleFinished.hidden = true
            backgroundTitle.hidden = false
            liveLabel.hidden = false
            countdownLabel.hidden = false
            
            timerDuration = Int(T_Album.getRemainingDuration(album!.createdAt!, duration: album!.duration))
            timerLiveAction()
            if let _ = timerLive {
                
            } else {
                self.timerLive = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(T_AlbumLiveTableViewCell.timerLiveAction), userInfo: nil, repeats: true)
            }
        } else {
            dateLabel.hidden = false
            backgroundTitleFinished.hidden = false
            backgroundTitle.hidden = true
            liveLabel.hidden = true
            countdownLabel.hidden = true
        }
        
        self.selectionStyle = .None
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
                if hour < 10 {
                    value += String(0)
                }
                value += String(hour)+":"
            }else {
                value += String(0)
                value += String(0)
                value += ":"
            }
            
            if min > 0 {
                if min < 10 {
                    value += String(0)
                }
                value += String(min)+":"
            }else {
                value += String(0)
                value += String(0)
                value += ":"
            }
            
            if second > 0 {
                if second < 10 {
                    value += String(0)
                }
                value += String(second)
            } else {
                value += String(0)
                value += String(0)
            }
            
            countdownLabel.text = value
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
