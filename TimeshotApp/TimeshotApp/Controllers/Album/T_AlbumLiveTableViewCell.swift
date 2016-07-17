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
        
        // FAIRE UN IF ELSE POUR LE LIVE et checker la photo a mettre
    }
    
    
    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
