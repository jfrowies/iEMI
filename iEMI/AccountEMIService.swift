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
    
    func credits(licensePlate licensePlate:String, start:Int, cant:Int ,completion: (result: () throws -> [Credit]) -> Void) -> Void {
        
        let endpointURL = "WorkWithDevicesEMCredito_EMCredito_List_Grid"
        let parameters = ["CreditoChapa":licensePlate,"start":String(start), "count":String(cant)]
        
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
    
    func balance(licensePlate licensePlate:String, completion: (result: () throws -> [Transaction]) -> Void) -> Void {
        
        var transactions = [Transaction]()
        
        self.credits(licensePlate: licensePlate, start: 0, cant: 5) { [unowned self] (result) -> Void in
            do {
                let credits = try result()
                for credit in credits {
                    transactions.append(credit)
                }
                
                self.sortElements(&transactions)
            
                self.debits(licensePlate: licensePlate, fromTimeStamp: transactions.last!.timestamp) { [unowned self] (result) -> Void in
                    do {
                        let debits = try result()
                        for debit in debits {
                            transactions.append(debit)
                        }
                        self.sortElements(&transactions)
                        
                        completion() { return transactions }
                        
                    } catch let error{
                        completion () { throw error }
                    }
                }
                
            } catch let error{
                completion () { throw error }
            }
        }
    
    }
    
    private func sortElements(inout elements:[Transaction]) {
        
        elements.sortInPlace({ (mov1: Transaction, mov2: Transaction) -> Bool in
            if mov1.timestamp > mov2.timestamp {
                return true
            }else if mov1.timestamp == mov2.timestamp {
                if mov1.isKindOfClass(Debit) {
                    return true
                }else {
                    return false
                }
            } else {
                return false
            }
        })
    }

}