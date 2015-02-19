//
//  TabBarIconFixerViewController.swift
//  iEMI
//
//  Created by Nicolas Ameghino on 2/19/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func iconName() -> String? { return nil }
}

class TabBarIconFixerViewController: UIViewController {
    override var tabBarItem: UITabBarItem! {
        get {
            let tbi = super.tabBarItem
            if let iconName = iconName() {
                if let img = UIImage(named: iconName) {
                    tbi.image = img
                    tbi.selectedImage = img
                }
            }
            return tbi
        }
        set {
            super.tabBarItem = newValue
        }
    }
}