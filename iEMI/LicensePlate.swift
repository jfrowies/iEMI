//
//  LicensePlate.swift
//  iEMI
//
//  Created by Fer Rowies on 8/18/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class LicensePlate: NSObject {
    
    let LICENSE_PLATE_KEY = "patenteKey"
    
    var currentLicensePlate: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(LICENSE_PLATE_KEY)
        }
        
        set (newLicensePlate) {
            let settings = NSUserDefaults.standardUserDefaults()
            settings.setObject(newLicensePlate?.uppercaseString, forKey:LICENSE_PLATE_KEY)
            settings.synchronize()
        }
    }

}
