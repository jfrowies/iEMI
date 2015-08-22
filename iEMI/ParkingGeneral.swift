//
//  FareGeneral.swift
//  iEMI
//
//  Created by Fer Rowies on 8/20/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class ParkingGeneral: Parking {
    
    var licensePlate: String?
    var fareType: String?
    var parkingDescription: String?
    var fareAmount: String?
    var parkingStatus: String?
    var parkingCashier: String?
    var parkingSpace: String?

    override init(json:[String:String]) {
        
        super.init(json: json)
        
        licensePlate = json["TarChapa"]
        fareType = json["TarTarifa"]
        parkingDescription = json["TarDescripcion"]
        fareAmount = json["TarMto"]
        parkingStatus = json["TarEstado"]
        parkingCashier = json["TarPostero"]
        parkingSpace = json["TarPostaNro"]
    }
    
}
