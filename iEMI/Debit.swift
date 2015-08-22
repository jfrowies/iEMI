//
//  Debit.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class Debit: NSObject, Transaction {

    var number: String?
    var year: String?
    var serie: String?
    
    var timestamp : String
    var date: String?
    var address: String?
    
    var timeStart: String?
    var timeEnd: String?
    
    var balance: String?

    var amount: String? {
        get {
            
            //temporary workaround
            let hourFrom = (self.timeStart! as NSString).substringToIndex(2)
            let minutesFrom = (self.timeStart! as NSString).substringWithRange(NSMakeRange(3, 2))
            let totalMinutesFrom = (Int(hourFrom)! * 60) + Int(minutesFrom)!
            
            let hourTo = (self.timeEnd! as NSString).substringToIndex(2)
            let minutesTo = (self.timeEnd! as NSString).substringWithRange(NSMakeRange(3, 2))
            let totalMinutesTo = (Int(hourTo)! * 60) + Int(minutesTo)!
            
            let minutes = totalMinutesTo - totalMinutesFrom
            
            let date = NSDate(dateJsonString: self.timestamp);
            
            let tarj55 = NSDate(dateString: "2015-03-02")
            
            if (tarj55.compare(date) == NSComparisonResult.OrderedAscending)
            {
                if minutes <= 60 {
                    return "5.50"
                }else if minutes <= 90 {
                    return "8.25"
                }else if  minutes <= 120 {
                    return "11.00"
                }
            }
            else
            {
                if minutes <= 60 {
                    return "4.50"
                }else if minutes <= 90 {
                    return "6.75"
                }else if  minutes <= 120 {
                    return "9.00"
                }
            }
           return "0.00"
        }
    }
    
    init(json:[String:AnyObject]) {
        
        number = json["TarNro"]!.description
        year = json["TarAno"]!.description
        serie = json["TarSerie"]!.description
        
        let timestampStartString : NSString = json["TarHoraIni"]!.description
        timestamp = timestampStartString as String
        date = timestampStartString.substringToIndex(10)
        timeStart = timestampStartString.substringWithRange(NSMakeRange(11, 5)) + " hs"
        
        let timestampEndString : NSString = json["TarHoraFin"]!.description
        timeEnd = timestampEndString.substringWithRange(NSMakeRange(11, 5)) + " hs"
        
        let addressString : NSString = json["TarAddress"]!.description
        address = addressString.stringByReplacingOccurrencesOfString(", Resistencia, Chaco", withString: "")
    }

}
