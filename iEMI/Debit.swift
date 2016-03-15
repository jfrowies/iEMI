//
//  Debit.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit


class Debit: NSObject, Transaction {
    
    private let kNoEndTimeString = "00:00"

    var number: String
    var year: String
    var serie: String
    
    var timestamp : String
    var date: String?
    var address: String?
    
    var timeStart: String?
    var timeEnd: String?
    
    var balance: String?
    var amount: String?

    init(json:[String:AnyObject]) {
        
        number = json["TarNro"]!.description
        year = json["TarAno"]!.description
        serie = json["TarSerie"]!.description
        
        let timestampStartString : NSString = json["TarHoraIni"]!.description
        timestamp = timestampStartString as String
        date = timestampStartString.substringToIndex(10)
        timeStart = timestampStartString.substringWithRange(NSMakeRange(11, 5)) + " " + kHrs
        
        let timestampEndString : NSString = json["TarHoraFin"]!.description
        
        let timeEndString =  timestampEndString.substringWithRange(NSMakeRange(11, 5))
            
        if timeEndString != kNoEndTimeString {
            timeEnd = timeEndString + " " + kHrs
        } else {
            timeEnd = nil
        }
        
        let addressString : NSString = json["TarAddress"]!.description
        address = addressString.stringByReplacingOccurrencesOfString(", Resistencia, Chaco", withString: "")
    }

}
