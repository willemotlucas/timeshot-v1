//
//  T_AlbumFinishTableViewCell.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 19/03/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AlbumFinishTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var coverAlbum: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleAlbumLabel: UILabel!
    
    // MARK: Initialisation
    func initCell(cover: UIImage, date: String, title :String){
        coverAlbum.image = cover
        dateLabel.text = date
        titleAlbumLabel.text = title
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
