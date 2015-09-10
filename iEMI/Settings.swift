//
//  Settings.swift
//  iEMI
//
//  Created by Fer Rowies on 9/9/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    let AUTO_LOGIN_KEY = "autoLoginKey"
    
    var autoLogin: Bool {
        
        get {
            return  !NSUserDefaults.standardUserDefaults().boolForKey(AUTO_LOGIN_KEY)
        }
        
        set (newValue) {
            let settings = NSUserDefaults.standardUserDefaults()
            settings.setObject(!newValue, forKey:AUTO_LOGIN_KEY)
            settings.synchronize()
        }
    }
    
}
