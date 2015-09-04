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
    
    lazy var icon: UIImage? = {
        if let imageName = self.iconName() {
            return UIImage(named: imageName)
        }
        return nil
        }()
    
    override var tabBarItem: UITabBarItem! {
        get {
            let tbi = super.tabBarItem
            tbi.image = icon
            tbi.selectedImage = icon
            return tbi
        }
        set {
            super.tabBarItem = newValue
        }
    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.navigationController?.navigationBar.translucent = true
//
//        self.navigationController?.navigationBar.backgroundColor = UIColor.orangeGlobalTintColor()
//    }
}