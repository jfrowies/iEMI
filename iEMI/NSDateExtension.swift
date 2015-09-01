//
//  NSDateExtension.swift
//  iEMI
//
//  Created by Guillermo Ruffino on 3/9/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import Foundation

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
}