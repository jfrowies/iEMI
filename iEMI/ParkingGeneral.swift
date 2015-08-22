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

    override init(json:[String:AnyObject]) {
        
        super.init(json: json)
        
        licensePlate = json["TarChapa"]?.description
        fareType = json["TarTarifa"]?.description
        parkingDescription = json["TarDescripcion"]?.description
        fareAmount = json["TarMto"]?.description
        parkingStatus = json["TarEstado"]?.description
        parkingCashier = json["TarPostero"]?.description
        parkingSpace = json["TarPostaNro"]?.description
    }
    
}
