//
//  Credito.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class Credito: NSObject, Movimiento {
    var creditoId: String?
    var fecha: String?
    var timestamp: String
    var hora: String?
    var importe: String?
    var saldo: String?
    
    
    init(json:[String:String]) {
        creditoId = json["CreditoID"]
        let fechaYHora : NSString = json["CreditoFecha"]!
        timestamp = fechaYHora as String
        fecha = fechaYHora.substringToIndex(10)
        hora = fechaYHora.substringWithRange(NSMakeRange(11, 5)) + " hs"
        importe = json["CreditoImporte"]
        //saldo = json["CreditoSaldo"] this is the saldo actual, non sense
    }
}
