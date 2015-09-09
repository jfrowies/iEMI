//
//  SettingsViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/19/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var appBuildLabel: UILabel!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - View controller life cycle
    
    let kAppVersionKey:String = "CFBundleShortVersionString"
    let kAppBuildKey:String = "CFBundleVersion"

    
    let licensePlateSotrage = LicensePlate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let appVersion = NSBundle.mainBundle().infoDictionary?[kAppVersionKey] as? String {
            self.appVersionLabel.text = appVersion
        }
        
        if let appBuild = NSBundle.mainBundle().infoDictionary?[kAppBuildKey] as? String {
            self.appBuildLabel.text = "(\(appBuild))"
        }
        
        self.licensePlateLabel.text = licensePlateSotrage.currentLicensePlate!
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions

    @IBAction func logoutButtonTouched(sender: AnyObject) {
        
        licensePlateSotrage.currentLicensePlate = nil
    
    }
    
    
}
