//
//  ParkingInformationService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/18/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

protocol ParkingInformationService: NSObjectProtocol {
    
    var service: Service { get set }
        
    func detail(parking:Parking , completion: (result: () throws -> ParkingGeneral) -> Void) -> Void
    
    func time(parking:Parking , completion: (result: () throws -> ParkingTime) -> Void) -> Void
    
    func location(parking:Parking , completion: (result: () throws -> ParkingLocation) -> Void) -> Void
    
}