//
//  Consumo.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class Consumo: NSObject, Movimiento {
    var tarNro: String?
    var tarSerie: String?
    var tarAno: String?

    var fecha: String?
    var direccion: String?
    
    var horaDesde: String?
    var horaHasta: String?

    var importe: String?
    
    init(json:[String:AnyObject]) {
        tarNro = json["TarNro"]?.description
        tarSerie = json["TarSerie"]?.description
        tarAno = json["TarAno"]?.description
        let fechaYHoraDesdeString : NSString = json["TarHoraIni"]!.description
        fecha = fechaYHoraDesdeString.substringToIndex(10)
        horaDesde = fechaYHoraDesdeString.substringWithRange(NSMakeRange(11, 5)) + " hs"
        
        let fechaYHoraHastaString : NSString = json["TarHoraFin"]!.description
        horaHasta = fechaYHoraHastaString.substringWithRange(NSMakeRange(11, 5)) + " hs"
        
        let direccionString : NSString = json["TarAddress"]!.description
        direccion = direccionString.stringByReplacingOccurrencesOfString(", Resistencia, Chaco", withString: "")
        
        importe = "0.0"
    }
}
