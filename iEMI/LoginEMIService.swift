//
//  LoginEMIService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/7/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class LoginEMIService: NSObject, LoginService {
    
    var service: Service = EMIService()
        
    func getSessionCookie(licensePlate licensePlate:String, completion: (result: () throws -> Bool) -> Void) -> Void {
        
        let endpointURL = "UpperChapa"
        let params = ["Tarchapa":licensePlate] as Dictionary<String, String>
        
        service.post(endpointURL, parameters: params) { (response) -> Void in
            completion(result: {
                do {
                    try response()
                    return true
                }
            })
        }
    }
    
    func authenticate(licensePlate licensePlate:String, password:String, completion: (result: () throws -> Bool) -> Void) -> Void {
        
        let endpointURL = "VerifPinSinHorario"
        let params = ["AutoPin":password,"AutoChapa":licensePlate] as Dictionary<String, String>

        service.post(endpointURL, parameters: params) { (response) -> Void in
            completion(result: {
                do {
                    try response()
                    return true
                }
            })
        }
    }
    
}
