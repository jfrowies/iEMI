//
//  ParkingCloseService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/22/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

protocol ParkingCloseService: NSObjectProtocol {

    var service: Service { get set }
    
    func getOpenParking(licensePlate:String ,completion: (result: () throws -> Parking) -> Void) -> Void
    
    func closeParking(parking:Parking , completion: (result: () throws -> Parking) -> Void) -> Void
    
}
