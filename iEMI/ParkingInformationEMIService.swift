//
//  ParkingInformationEMIService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/22/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class ParkingInformationEMIService: NSObject {
    
    var service: EMIService = EMIService()
    
    func detail(parking:Parking , completion: (result: () throws -> ParkingGeneral) -> Void) -> Void {
        
        let endpointURL = "WorkWithDevicesTarjetas_Tarjetas_Section_General"
        let parameters = ["TarNro":parking.number, "TarAno":parking.year, "TarSerie":parking.serie]
        
        service.get(endpointURL, parameters: parameters) { (response) -> Void in
            completion (result: { () -> ParkingGeneral in
                do {
                    if let jsonParkingGeneral = try response() as? [String:AnyObject] {
                        
                        return ParkingGeneral(json: jsonParkingGeneral)
                    }
                    //if reached this point the response data was not valid
                    throw ServiceError.ResponseInformationError
                }
            })
        }
    }
    
    func time(parking:Parking , completion: (result: () throws -> ParkingTime) -> Void) -> Void {
        
        let endpointURL = "WorkWithDevicesTarjetas_Tarjetas_Section_Horario"
        let parameters = ["TarNro":parking.number, "TarAno":parking.year, "TarSerie":parking.serie]
    
        service.get(endpointURL, parameters: parameters) { (response) -> Void in
            completion (result: { () -> ParkingTime in
                do {
                    if let jsonParkingTime = try response() as? [String:AnyObject] {
             
                        return ParkingTime(json: jsonParkingTime)
                    }
                    //if reached this point the response data was not valid
                    throw ServiceError.ResponseInformationError
                }
            })
        }
    }
    
    func location(parking:Parking , completion: (result: () throws -> ParkingLocation) -> Void) -> Void {
        
        let endpointURL = "WorkWithDevicesTarjetas_Tarjetas_Section_Ubicacion"
        let parameters = ["TarNro":parking.number ,"TarAno": parking.year, "TarSerie":parking.serie]
        
        service.get(endpointURL, parameters: parameters) { (response) -> Void in
            completion (result: { () -> ParkingLocation in
                do {
                    if let jsonParkingLocation = try response() as? [String:AnyObject] {
                        
                        return ParkingLocation(json: jsonParkingLocation)
                    }
                    //if reached this point the response data was not valid
                    throw ServiceError.ResponseInformationError
                }
            })
        }
    }
    

}