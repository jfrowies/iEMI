//
//  LoginResult.swift
//  iEMI
//
//  Created by Fer Rowies on 8/7/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class LoginResult: NSObject {
    
    var loginSuccessful: Bool
    var message: String?
    
    init(_ loginSuccessful:Bool) {
        self.loginSuccessful = loginSuccessful;
    }
    
    init(_ loginSuccessful:Bool, message:String?) {
        self.loginSuccessful = loginSuccessful
        self.message = message
    }
    
}
