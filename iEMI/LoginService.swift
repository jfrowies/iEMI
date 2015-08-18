//
//  LoginService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/7/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

protocol LoginService: NSObjectProtocol {
    
    var service: Service { get set }
    
    func authenticate(licensePlate licensePlate:String, password:String, completion: (result: () throws -> Bool) -> Void) -> Void
    
    func getSessionCookie(licensePlate licensePlate:String, completion: (result: () throws -> Bool) -> Void) -> Void
    
}