//
//  Parking.swift
//  iEMI
//
//  Created by Fer Rowies on 8/19/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class Parking: NSObject {
    var number: String?
    var year: String?
    var serie: String?
    
    init(json:[String:AnyObject]) {
        number = json["TarNro"]?.description
        year = json["TarAno"]?.description
        serie = json["TarSerie"]?.description
    }
    
    init(number:String?, year:String?, serie:String?) {
        self.number = number
        self.year = year
        self.serie = serie
    }
    
}
