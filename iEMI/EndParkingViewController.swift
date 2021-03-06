//
//  EndParkingViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class EndParkingViewController: NetworkActivityViewController {
    
    @IBOutlet private weak var closeButton: UIButton!
    
    let service: ParkingCloseEMIService = ParkingCloseEMIService()
    
    let licensePlate = LicensePlate()

    var parking: Parking?
    
    weak var parkingInformationViewController : ParkingInformationViewController?
    
    private let kShowParkingInformationSegue: String = "showParkingInformation"
    
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refresh(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowParkingInformationSegue {
            self.parkingInformationViewController = segue.destinationViewController as? ParkingInformationViewController
        }
    }
    
    // MARK: - IBActions
    
    private let kLoadingParkingText = NSLocalizedString("Loading parking", comment: "loading parking message in close parking")
    
    @IBAction func refresh(sender:AnyObject?) {
        
        self.closeButton.enabled = false
        self.loadParking()
    }
    
    @IBAction func closeButtonTouched(sender: UIButton) {
        
        guard let currentParking = self.parking else {
            
            self.showError(nil,errorMessage: kErrorLoadingClosingText)
            return
        }
        
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("Are you sure you want to close this parking?", comment: "Close parking action sheet message"), preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title in action sheet"), style: .Cancel) { (action) in
            // Do nothing
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: NSLocalizedString("Close parking", comment: "Close parking action in action sheet"), style: .Destructive) { [unowned self] (action) in
            self.closeParking(currentParking)
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true) {}
    }
    
    // MARK: -
    
    private func showError(error: NSError?, errorMessage: String?) {
        
        if let currentError = error {
            print("Error: \(currentError.localizedDescription)")
        }
        self.showErrorView(errorMessage, animated:false)
    }
    
    // MARK: - service calls
    
    private let kErrorLoadingParkingText = NSLocalizedString("Error loading parking. Try again please.", comment: "error loading parking")
    
    private func loadParking() {
        
        guard let currentLicensePlate = licensePlate.currentLicensePlate else {
            self.showError(nil,errorMessage: kErrorLoadingParkingText)
            return
        }
        
        self.showLoadingView(kLoadingParkingText, animated: false)
        
        service.getOpenParking(currentLicensePlate) { [unowned self] (result) -> Void in
            
            do {
                let parking = try result()
            
                self.parking = parking
                
                self.parkingInformationViewController?.parking = self.parking
                self.parkingInformationViewController?.reloadParking()

                self.closeButton.enabled = true
                
                self.hideLoadingView(animated: true)
                
            } catch ServiceError.ResponseErrorMessage(let errorMessage){
                
                self.showError(nil,errorMessage: errorMessage)

            } catch let error {
                self.showError(error as NSError, errorMessage: self.kErrorLoadingParkingText)
            }
        }
    
    }
    
    private let kErrorLoadingClosingText = NSLocalizedString("Error closing parking. Refresh and try again please.", comment: "error closing parking")
    
    private let kClosingParkingText = NSLocalizedString("Closing parking", comment: "closing parking message in close parking")
    
    private let kSuccessClosingParkingText = NSLocalizedString("Parking successfully closed", comment: "parking successfully closed message in close parking")
    
    private func closeParking(parking: Parking) {
        
        self.showLoadingView(kClosingParkingText, animated: false)

        service.closeParking(parking) { [unowned self] (result) -> Void in
            
            do {
                try result()
                self.showSuccessView(self.kSuccessClosingParkingText, animated: false)
                
            } catch let error {
                
                if let serviceError = error as? ServiceError {
                    switch serviceError {
                    case .ResponseSuccessfullMessage:
                        self.showSuccessView(self.kSuccessClosingParkingText, animated: false)
                    default:
                        self.showError(error as NSError, errorMessage: self.kErrorLoadingClosingText)
                    }
                } else {
                    self.showError(error as NSError, errorMessage: self.kErrorLoadingClosingText)
                }
            }
        }
    }
}
