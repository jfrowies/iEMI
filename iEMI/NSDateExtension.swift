//
//  NSDateExtension.swift
//  iEMI
//
//  Created by Guillermo Ruffino on 3/9/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import Foundation


let kTodayString: String = NSLocalizedString("today", comment: "today srting")
let kYesterdayString: String = NSLocalizedString("yesterday", comment: "yesterday srting")

extension NSDate
{
    convenience
    init(dateJsonString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateJsonString)
        self.init(timeInterval:0, sinceDate:d!)
    }
    
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }

    
    func formattedDateString() -> String {
        
        let calendarUnits: NSCalendarUnit = [.Era, .Year, .Month, .Day]
        
        let calendar = NSCalendar.currentCalendar()
        let todayComponents = calendar.components(calendarUnits, fromDate: NSDate())
        let today = calendar.dateFromComponents(todayComponents)
        
        let yestardayFullDate = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
        let yesterdayComponents = calendar.components(calendarUnits, fromDate: yestardayFullDate!)
        let yesterday = calendar.dateFromComponents(yesterdayComponents)
        
        let dateComponents =  calendar.components(calendarUnits, fromDate: self)
        let date = calendar.dateFromComponents(dateComponents)
        
        if (date!.isEqualToDate(today!)) {
            return kTodayString
        } else if (date!.isEqualToDate(yesterday!)) {
            return kYesterdayString
        }
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        return formatter.stringFromDate(self)
    }
}