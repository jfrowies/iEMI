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
    var startTime: String?
    var endTime: String?
    var maxEndTime: String?
    var parkingTime: String?
    var parkingStatus : ParkingStatus!
    
    override init(json:[String:AnyObject]) {
        
        super.init(json: json)
        
        date = json["TarFecha"]?.description
        startTime = json["TarHoraIni"]?.description
        endTime = json["TarHoraFin"]?.description
        maxEndTime = json["TarFinMax"]?.description
        parkingTime = json["TarTiempo"]?.description
    
        parkingStatus = endTime == kParkingEndTimeEmpty ? ParkingStatus.Parked : ParkingStatus.Closed
    }
    
}
