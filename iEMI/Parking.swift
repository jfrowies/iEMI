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
        
        if let number = json["TarNro"] as? String {
            self.number = number
        }
        
        if let year = json["TarAno"] as? String {
            self.year = year
        }
        
        if let serie = json["TarSerie"] as? String {
            self.serie = serie
        }
    }
    
    init(number:String, year:String, serie:String) {
        self.number = number
        self.year = year
        self.serie = serie
    }
    
}
