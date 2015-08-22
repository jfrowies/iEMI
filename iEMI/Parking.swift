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
    
    init(json:[String:String]) {
        number = json["TarNro"]
        year = json["TarAno"]
        serie = json["TarSerie"]
    }
    
}
