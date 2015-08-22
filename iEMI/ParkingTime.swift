//
//  ParkingTime.swift
//  iEMI
//
//  Created by Fer Rowies on 8/22/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class ParkingTime: Parking {
    
    var date: String?
    var startTime: String?
    var endTime: String?
    var maxEndTime: String?
    var parkingTime: String?
    
    override init(json:[String:String]) {
        
        super.init(json: json)
        
        date = json["TarFecha"]
        startTime = json["TarHoraIni"]
        endTime = json["TarHoraFin"]
        maxEndTime = json["TarFinMax"]
        parkingTime = json["TarTiempo"]
    }
    
}
