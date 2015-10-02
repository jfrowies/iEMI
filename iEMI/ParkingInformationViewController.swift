//
//  ParkingInformationViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/17/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

let kHrs: String = NSLocalizedString("hrs", comment: "Hours abbreviation srting")
let kMin: String = NSLocalizedString("min", comment: "Minutes abbreviation srting")

class ParkingInformationViewController: NetworkActivityViewController {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var parkingDurationLabel: UILabel!
    @IBOutlet private weak var parkingStatusLabel: UILabel!
    @IBOutlet private weak var slidingMapView: SlidingMapView!
    
    let service: ParkingInformationService = ParkingInformationEMIService()
    var parking: Parking?
    
    //MARK: - UI Constants
    
    private let kParkingStatusParked: String = NSLocalizedString("parked", comment: "Parking status parked string")
    private let kParkingStatusClosed: String = NSLocalizedString("closed", comment: "Parking status closed string")
    private let kParkingEndTimeEmpty: String = "0000-00-00T00:00:00"

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadParking()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.reloadParking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Public methods
    
    func reloadParking() {
                
        self.slidingMapView.address = nil
        self.dateLabel.text = ""
        self.startTimeLabel.text = ""
        self.endTimeLabel.text = ""
        self.parkingDurationLabel.text = ""
        self.parkingStatusLabel.text = ""
        
        self.loadLocation()
        self.loadTime()
    }
    
    // MARK: - Private methods
    
    private let kErrorLoadingParkingDataText = NSLocalizedString("Error loading parking data. Try again please.", comment: "error loading parking data message")
    
    private let kLoadingParkingDataText = NSLocalizedString("Loading parking data", comment: "loading parking data message")
    
    private func showError(error: NSError?, errorMessage: String?) {
        
        if let currentError = error {
            print("Error: \(currentError.localizedDescription)")
        }
        self.showErrorView(errorMessage, animated:false)
    }
    
    // MARK: - service calls
    
    private func loadLocation() {
        
        guard let currentParking = self.parking else {
            self.showError(nil, errorMessage: kErrorLoadingParkingDataText)
            return
        }
        
        service.location(currentParking) { [weak self] (result) -> Void in
            
            do {
                let parkingLocation = try result()
                self?.slidingMapView.address = parkingLocation.fullAddress
                
            } catch let error as NSError{
                self?.showError(error, errorMessage: self?.kErrorLoadingParkingDataText)
            }
        }
    }
    
    private func loadTime() {
        
        guard let currentParking = self.parking else {
            self.showError(nil, errorMessage: kErrorLoadingParkingDataText)
            return
        }
        
        self.showLoadingView(kLoadingParkingDataText, animated: false)

        service.time(currentParking) { [weak self] (result) -> Void in
            
            do {
                let parkingTime = try result()
                
                self?.dateLabel.text = parkingTime.date
                
                let startTime = parkingTime.startTime! as NSString
                self?.startTimeLabel.text = startTime.substringFromIndex(11) + " " + kHrs

                let endTime = parkingTime.endTime! as NSString
                self?.endTimeLabel.text = endTime.substringFromIndex(11) + " " + kHrs

                let duration = parkingTime.parkingTime!
                let hours = Int(duration)!/60 as Int
                let minutes = Int(duration)! % 60

                self?.parkingDurationLabel.text = String("\(hours) \(kHrs) \(minutes) \(kMin)")

                self?.parkingStatusLabel.text = parkingTime.endTime == self?.kParkingEndTimeEmpty ? self?.kParkingStatusParked: self?.kParkingStatusClosed
                
                self?.hideLoadingView(animated: true)

            } catch let error as NSError{
                self?.showError(error, errorMessage: self?.kErrorLoadingParkingDataText)
            }
        }
    }
    
}
