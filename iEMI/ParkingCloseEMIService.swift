//
//  ParkingCloseEMIService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/22/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class ParkingCloseEMIService: NSObject, ParkingCloseService {
    
    var service: Service = EMIService()
    
    func getOpenParking(licensePlate:String, completion: (result: () throws -> Parking) -> Void) -> Void {
        
        let endpointURL = "BuscaTarjeta"
        let parameters = ["Tarchapa":licensePlate] as Dictionary<String, String>

        service.post(endpointURL, parameters: parameters) { (response) -> Void in
            completion (result: { () -> Parking in
                do {
                    if let parking = try response() as? [String:AnyObject] {
                        
                        return Parking(json: parking)
                    }
                    //if reached this point the response data was not valid
                    throw ServiceError.ResponseInformationError
                }
            })
        }
    }
    
    func closeParking(parking:Parking , completion: (result: () throws -> Parking) -> Void) -> Void {
        
        let endpointURL = "CloseTarjeta"
        let parameters = ["TarNro":parking.number!, "TarAno":parking.year!, "TarSerie":parking.serie!]
        
        service.post(endpointURL, parameters: parameters) { (response) -> Void in
            completion (result: { () -> Parking in
                do {
                    if let parking = try response() as? [String:AnyObject] {
                        
                        return Parking(json: parking)
                    }
                    //if reached this point the response data was not valid
                    throw ServiceError.ResponseInformationError
                }
            })
        }
    }

}
