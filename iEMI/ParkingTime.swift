//
//  ParkingTime.swift
//  iEMI
//
//  Created by Fer Rowies on 8/22/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

enum ParkingStatus {
    case Closed
    case Parked
}

class ParkingTime: Parking {
    
    private let kParkingEndTimeEmpty: String = "0000-00-00T00:00:00"
    
    var date: String?
    var startTimeStamp: String?
    var endTimeStamp: String?
    var maxEndTimeStamp: String?
    var parkingDuration: String?
    var parkingStatus : ParkingStatus!
    
    var startTime: String {
        get {
            
            guard let timeStamp = startTimeStamp else {
                return ""
            }
            
            return timeStamp.substringWithRange(Range<String.Index>(start: timeStamp.startIndex.advancedBy(11), end: timeStamp.endIndex.advancedBy(-3)))
        }
    }
    
    var endTime: String {
        get {
            guard let timeStamp = endTimeStamp else {
                return ""
            }
            
            return timeStamp.substringWithRange(Range<String.Index>(start: timeStamp.startIndex.advancedBy(11), end: timeStamp.endIndex.advancedBy(-3)))
        }
    }
    
    
    override init(json:[String:AnyObject]) {
        
        super.init(json: json)
        
        date = json["TarFecha"]?.description
        startTimeStamp = json["TarHoraIni"]?.description
        endTimeStamp = json["TarHoraFin"]?.description
        maxEndTimeStamp = json["TarFinMax"]?.description
        parkingDuration = json["TarTiempo"]?.description
    
        parkingStatus = endTimeStamp == kParkingEndTimeEmpty ? ParkingStatus.Parked : ParkingStatus.Closed
    }
    
}
