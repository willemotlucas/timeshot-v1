//
//  T_DateHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 07/06/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation

enum dayOfWeek: String {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

class T_DateHelper {
    
    static func getDayOfWeek()->Int? {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let myComponents = myCalendar?.components(.NSWeekdayCalendarUnit, fromDate: todayDate)
        let weekDay = myComponents?.weekday
        return weekDay
    }
    
    static func getDayOfWeekInLetter() -> String {
        let today = getDayOfWeek()! - 1
        
        switch today {
        case 1:
            return dayOfWeek.Monday.rawValue
        case 2:
            return dayOfWeek.Tuesday.rawValue
        case 3:
            return dayOfWeek.Wednesday.rawValue
        case 4:
            return dayOfWeek.Thursday.rawValue
        case 5:
            return dayOfWeek.Friday.rawValue
        case 6:
            return dayOfWeek.Saturday.rawValue
        case 7:
            return dayOfWeek.Sunday.rawValue
        default:
            return "Day"
        }
    }

}