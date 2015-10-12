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
    
    var streetNameAndNumber: String? {
        get {
            return fullAddress?.stringByReplacingOccurrencesOfString(", Resistencia, Chaco", withString: "")
        }
    }
    
    override init(json:[String:AnyObject]) {
        
        super.init(json: json)
        
        fullAddress = json["TarAddress"]?.description
        streetId = json["TarCallecod"]?.description
        streetName = json["TarCalleDenom"]?.description
        streetNumberMin = json["TarCalleDesde"]?.description
        streetNumberMax = json["TarCalleHasta"]?.description
        streetSide = json["TarCalleMano"]?.description
        parkingSpace = json["TarPostaNro"]?.description
        parkingSpaceZone = json["TarPostaZona"]?.description

    }
    
}
