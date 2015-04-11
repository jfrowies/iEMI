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

    var timestamp : String
    var fecha: String?
    var direccion: String?
    
    var horaDesde: String?
    var horaHasta: String?

    var importe: String? {
        get {
            
            //chanchada provisioria
            
            let desdeHoras = (self.horaDesde! as NSString).substringToIndex(2)
            let desdeMinutos = (self.horaDesde! as NSString).substringWithRange(NSMakeRange(3, 2))
            let desdeTotalMinutos = (desdeHoras.toInt()! * 60) + desdeMinutos.toInt()!
            
            let hastaHoras = (self.horaHasta! as NSString).substringToIndex(2)
            let hastaMinutos = (self.horaHasta! as NSString).substringWithRange(NSMakeRange(3, 2))
            let hastaTotalMinutos = (hastaHoras.toInt()! * 60) + hastaMinutos.toInt()!
            
            let minutos = hastaTotalMinutos - desdeTotalMinutos
            
            let date = NSDate(dateJsonString: self.timestamp);
            
            let tarj55 = NSDate(dateString: "2015-03-02")
            
            if (tarj55.compare(date) == NSComparisonResult.OrderedAscending)
            {
                if minutos <= 60 {
                    return "5.50"
                }else if minutos <= 90 {
                    return "7.75"
                }else if  minutos <= 120 {
                    return "11.00"
                }
            }
            else
            {
                if minutos <= 60 {
                    return "4.50"
                }else if minutos <= 90 {
                    return "6.75"
                }else if  minutos <= 120 {
                    return "9.00"
                }
            }
           return "0.00"
        }
    }
    
    init(json:[String:AnyObject]) {
        tarNro = json["TarNro"]?.description
        tarSerie = json["TarSerie"]?.description
        tarAno = json["TarAno"]?.description
        let fechaYHoraDesdeString : NSString = json["TarHoraIni"]!.description
        timestamp = fechaYHoraDesdeString as String
        fecha = fechaYHoraDesdeString.substringToIndex(10)
        horaDesde = fechaYHoraDesdeString.substringWithRange(NSMakeRange(11, 5)) + " hs"
        
        let fechaYHoraHastaString : NSString = json["TarHoraFin"]!.description
        horaHasta = fechaYHoraHastaString.substringWithRange(NSMakeRange(11, 5)) + " hs"
        
        let direccionString : NSString = json["TarAddress"]!.description
        direccion = direccionString.stringByReplacingOccurrencesOfString(", Resistencia, Chaco", withString: "")

    }
    
//    func calcularImporte(#desde: String, hasta: String) -> Float {
//        
//        return 4.5;
//    }
}
