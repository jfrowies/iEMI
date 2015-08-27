//
//  ParkingInformationViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/17/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class ParkingInformationViewController: TabBarIconFixerViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var parkingDurationLabel: UILabel!
    @IBOutlet weak var parkingStatusLabel: UILabel!
    
    @IBOutlet weak var locationSpinner: UIActivityIndicatorView!
    @IBOutlet weak var timeSpinner: UIActivityIndicatorView!
    
    let service: ParkingInformationService = ParkingInformationEMIService()
    
    var parking: Parking?
    
    //MARK: - UI Constants
    
    private let kHrs: String = NSLocalizedString("hrs", comment: "Hours abbreviation srting")
    private let kMin: String = NSLocalizedString("min", comment: "Minutes abbreviation srting")
    private let kParkingStatusParked: String = NSLocalizedString("parked", comment: "Parking status parked string")
    private let kParkingStatusClosed: String = NSLocalizedString("closed", comment: "Parking status closed string")
    private let kParkingEndTimeEmpty: String = "0000-00-00T00:00:00"

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: shouldn't do this
        self.reloadParking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func reloadParking() {
                
        self.addressLabel.text = ""
        self.dateLabel .text = ""
        self.startTimeLabel.text = ""
        self.endTimeLabel.text = ""
        self.parkingDurationLabel.text = ""
        self.parkingStatusLabel.text = ""
        
        self.loadLocation()
        self.loadTime()
    }

    // MARK: - IBActions
    
    
    // MARK: - service calls
    
    private func loadLocation() {
        
        guard let currentParking = self.parking else {
            return
        }
        
        self.locationSpinner.startAnimating()
        
        service.location(currentParking) { [unowned self] (result) -> Void in
            
            do {
                let parkingLocation = try result()
                self.addressLabel.text = parkingLocation.fullAddress
                self.locationSpinner.stopAnimating()
                
            } catch let error{
                
                print("Error: \(error)")
                self.locationSpinner.stopAnimating()
            }
        }
    }
    
    private func loadTime() {
        
        guard let currentParking = self.parking else {
            return
        }
        
        self.timeSpinner.startAnimating()

        service.time(currentParking) { [unowned self] (result) -> Void in
            
            do {
                let parkingTime = try result()
                
                self.dateLabel.text = parkingTime.date
                
                let startTime = parkingTime.startTime! as NSString
                self.startTimeLabel.text = startTime.substringFromIndex(11) + " " + self.kHrs

                let endTime = parkingTime.endTime! as NSString
                self.endTimeLabel.text = endTime.substringFromIndex(11) + " " + self.kHrs

                let duration = parkingTime.parkingTime!
                let hours = Int(duration)!/60 as Int
                let minutes = Int(duration)! % 60

                self.parkingDurationLabel.text = String("\(hours) \(self.kHrs) \(minutes) \(self.kMin)")

                self.parkingStatusLabel.text = parkingTime.endTime == self.kParkingEndTimeEmpty ? self.kParkingStatusParked: self.kParkingStatusClosed
                self.timeSpinner.stopAnimating()

            } catch let error{
                
                print("Error: \(error)")
                self.timeSpinner.stopAnimating()
              
            }
        }
    }
    
}
