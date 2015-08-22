//
//  AccountEMIService.swift
//  iEMI
//
//  Created by Fer Rowies on 8/18/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class AccountEMIService: NSObject, AccountService {
    
    var service: Service = EMIService()
    
    func accountBalance(licensePlate licensePlate:String, completion: (result: () throws -> Double) -> Void) -> Void {
        
        let endpointURL = "WorkWithDevicesEMCredito_EMCredito_List"
        let parameters = ["CreditoChapa":licensePlate]
        
        service.get(endpointURL, parameters: parameters) { (response) -> Void in
            completion (result: { () -> Double in
                do {
                    if let jsonBalance = try response() as? [String:String] {
                        if let balance = jsonBalance["Creditosaldo"] {
                            return (balance as NSString).doubleValue
                        }
                    }
                    //if reached this point the response data was not valid
                    throw ServiceError.ResponseInformationError
                }
            })
        }
    }
    
    func credits(licensePlate licensePlate:String, cant:Int ,completion: (result: () throws -> [Credit]) -> Void) -> Void {
        
        let endpointURL = "WorkWithDevicesEMCredito_EMCredito_List_Grid"
        let parameters = ["CreditoChapa":licensePlate, "count":String(cant)]
        
        service.get(endpointURL, parameters: parameters) { (response) -> Void in
            completion (result: { () -> [Credit] in
                do {
                    if let jsonCredits = try response() as? [[String:String]] {
                        var credits = [Credit]()
                        for jsonCredit in jsonCredits {
                            credits.append(Credit(json: jsonCredit))
                        }
                        return credits
                    }
                    //if reached this point the response data was not valid
                    throw ServiceError.ResponseInformationError
                }
            })
        }
    }
    
    func debits(licensePlate licensePlate:String, fromTimeStamp:String ,completion: (result: () throws -> [Debit]) -> Void) -> Void {
        
        let endpointURL = "WorkWithDevicesTarjetas_UltimosConsumos_List_Grid"
        let parameters = ["TarChapa":licensePlate, "Tarhoraini":fromTimeStamp]
        
        service.get(endpointURL, parameters: parameters) { (response) -> Void in
            completion (result: { () -> [Debit] in
                do {
                    if let jsonDebits = try response() as? [[String:AnyObject]] {
                        var debits = [Debit]()
                        for jsonDebit in jsonDebits {
                            debits.append(Debit(json: jsonDebit))
                        }
                        return debits
                    }
                    //if reached this point the response data was not valid
                    throw ServiceError.ResponseInformationError
                }
            })
        }
    }

}