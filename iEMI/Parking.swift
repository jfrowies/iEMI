//
//  Parking.swift
//  iEMI
//
//  Created by Fer Rowies on 8/19/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class Parking: NSObject {
    var number: String = ""
    var year: String = ""
    var serie: String = ""
    
    init(json:[String:AnyObject]) {
        
        //The service returns "TarNro" or "Tarnro"
        if let number = json["TarNro"] as? String {
            self.number = number
        }
        
        if let number = json["Tarnro"] as? String {
            self.number = number
        }
        
        //The service returns "TarAno" or "Tarano"
        if let year = json["TarAno"] as? String {
            self.year = year
        }
        
        if let year = json["TarAno"] as? Int {
            self.year = String(year)
        }
        
        if let year = json["Tarano"] as? String {
            self.year = year
        }
        
        if let year = json["Tarano"] as? Int {
            self.year = String(year)
        }
        
        //The service returns "TarSerie" or "Tarserie"
        if let serie = json["TarSerie"] as? String {
            self.serie = serie
        }
        
        if let serie = json["Tarserie"] as? String {
            self.serie = serie
        }
    }
    
    init(number:String, year:String, serie:String) {
        self.number = number
        self.year = year
        self.serie = serie
    }
    
}
