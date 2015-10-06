//
//  EMIColorsExtension.swift
//  iEMI
//
//  Created by Fer Rowies on 8/28/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

extension UIColor {
    
   static func orangeGlobalTintColor() -> UIColor {
        return UIColor(red: 250.0/255.0, green: 102.0/255.0, blue: 4.0/255.0, alpha: 1.0)
    }
    
    static func grayBackgroundColor() -> UIColor {
        return UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
    
    static func lightGrayBackgroundColor() -> UIColor {
        return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
    
    static func grayLabelDefaultColor() -> UIColor { //3A3A3A
        return UIColor(red: 58.0/255.0, green: 58.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    }
    
    static func grayCreditBalanceViewBackgroundColor() -> UIColor { //3A3A3A
        return UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1.0)
    }
    
    static func redErrorColor() -> UIColor {
        return UIColor.redColor()
    }
    
}