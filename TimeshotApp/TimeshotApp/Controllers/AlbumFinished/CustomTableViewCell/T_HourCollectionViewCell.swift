//
//  HourCollectionViewCell.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_HourCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    @IBOutlet weak var hourLabel: UILabel!
    
    // MARK: Functions
    func initHourLabel(date: NSDate){
        let calendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .Hour
        
        // On veut d'abord avoir l'heure actuelle que l'on recupere en Int
        let hour = calendar.component(unit, fromDate: date)
        hourLabel.text = "\(hour)h"
    }
    
}
