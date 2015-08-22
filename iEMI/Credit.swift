//
//  Credit.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class Credit: NSObject, Transaction {
    
    var creditId: String?
    var date: String?
    var timestamp: String
    var time: String?
    var amount: String?
    var balance: String?
    
    init(json:[String:String]) {
        creditId = json["CreditoID"]
        let fechaYHora : NSString = json["CreditoFecha"]!
        timestamp = fechaYHora as String
        date = fechaYHora.substringToIndex(10)
        time = fechaYHora.substringWithRange(NSMakeRange(11, 5)) + " hs"
        amount = json["CreditoImporte"]
        //balance = json["CreditoSaldo"] this is the balance actual, non sense
    }
    
}
