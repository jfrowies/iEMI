//
//  EndParkingViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class EndParkingViewController: NetworkActivityViewController {

    @IBOutlet weak var closeSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    let service: ParkingCloseService = ParkingCloseEMIService()
    
    let licensePlate = LicensePlate()

    var parking: Parking?
    
    weak var parkingInformationViewController : ParkingInformationViewController?
    
    private let kShowParkingInformationSegue: String = "showParkingInformation"
    
    private let kLoadingParkingText = NSLocalizedString("Loading parking", comment: "loading parking message in close parking")
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showLoadingView(kLoadingParkingText, animated: false)
        
        self.closeSpinner.stopAnimating()
        self.closeButton.enabled = true
        
        self.loadParking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func closeButtonTouched(sender: UIButton) {
        
        guard let currentParking = self.parking else {
            return
        }
        
        self.closeParking(currentParking)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowParkingInformationSegue {
            self.parkingInformationViewController = segue.destinationViewController as? ParkingInformationViewController
        }
    }
    
    // MARK: -
    
    private func showError(error: String) {
        
        self.showErrorView(error, animated: false)
    }
    
    // MARK: - service calls
    
    private func loadParking() {
        
        guard let currentLicensePlate = licensePlate.currentLicensePlate else {
            return
        }
        
        service.getOpenParking(currentLicensePlate) { [unowned self] (result) -> Void in
            
            do {
                let parking = try result()
            
                self.parking = parking
                
                self.parkingInformationViewController?.parking = self.parking
                self.parkingInformationViewController?.reloadParking()

                self.hideLoadingView(true)
                
                self.closeButton.enabled = true
          
            } catch ServiceError.ResponseErrorMessage(let errorMessage){
                
                self.showError(errorMessage!)

            } catch {
                self.showError("Error")
            }
        }
    
    }
    
    private func closeParking(parking:Parking) {
        
        self.closeButton.enabled = false
        self.closeSpinner.startAnimating()
        
        service.closeParking(parking) { [unowned self] (result) -> Void in
            
            self.closeSpinner.stopAnimating()

            do {
                try result()
                
            } catch {
                self.parkingInformationViewController?.reloadParking()
                self.closeButton.enabled = true
            }
        }
    }
}
