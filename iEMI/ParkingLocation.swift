//
//  ParkingLocation.swift
//  iEMI
//
//  Created by Fer Rowies on 8/22/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class ParkingLocation: Parking {
    
    var fullAddress: String?
    var streetId: String?
    var streetName: String?
    var streetNumberMin: String?
    var streetNumberMax: String?
    var streetSide: String?
    var parkingSpace: String?
    var parkingSpaceZone: String?
    
    override init(json:[String:String]) {
        
        super.init(json: json)
        
        fullAddress = json["TarAddress"]
        streetId = json["TarCallecod"]
        streetName = json["TarCalleDenom"]
        streetNumberMin = json["TarCalleDesde"]
        streetNumberMax = json["TarCalleHasta"]
        streetSide = json["TarCalleMano"]
        parkingSpace = json["TarPostaNro"]
        parkingSpaceZone = json["TarPostaZona"]

    }
    
}
