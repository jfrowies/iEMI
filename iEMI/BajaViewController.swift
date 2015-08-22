//
//  BajaViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class BajaViewController: TabBarIconFixerViewController {

    @IBOutlet weak var loadingFeedback: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var bajaSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tarjetaLabel: NSLayoutConstraint!
    @IBOutlet weak var bajaButton: UIButton!
    
    let service: ParkingCloseService = ParkingCloseEMIService()
    let licensePlate = LicensePlate()

    var tarjeta: Parking?
    
    weak var tarjetaViewController : TarjetaViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func iconName() -> String { return "baja" }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingView.hidden = false
        self.loadingSpinner.startAnimating()
        self.loadingFeedback.text = "Cargando tarjeta"
        
        self.bajaSpinner.stopAnimating()
        self.bajaButton.enabled = true
        
        self.loadTarjeta()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func bajaButtonTouched(sender: UIButton) {
        
        guard let currentParking = self.tarjeta else {
            return
        }
        
        self.bajaTarjeta(currentParking)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTarjeta" {
            self.tarjetaViewController = segue.destinationViewController as? TarjetaViewController
        }
    }
    
    // MARK: -
    
    func patente() ->String {
        return NSUserDefaults.standardUserDefaults().stringForKey("patenteKey")!
    }
    
    func showError(error: String) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.loadingFeedback.text = error
            self.loadingFeedback.hidden = false
            self.loadingSpinner.stopAnimating()
        })
    }
    
    // MARK: - service calls
    
    func loadTarjeta() {
        
        service.getOpenParking(licensePlate.currentLicensePlate!) { [unowned self] (result) -> Void in
            
            do {
                let parking = try result()
            
                self.tarjeta = parking
                
                self.tarjetaViewController?.tarjeta = self.tarjeta
                self.tarjetaViewController?.reloadTarjeta()
                self.loadingView.hidden = true
                self.bajaButton.enabled = true
          
            } catch ServiceError.ResponseErrorMessage(let errorMessage){
                
                self.showError(errorMessage!)

            } catch {
                self.showError("Error")

            }
        }
    
    }
    
    func bajaTarjeta(parking:Parking) {
        
        self.bajaButton.enabled = false
        self.bajaSpinner.startAnimating()
        
        service.closeParking(parking) { [unowned self] (result) -> Void in
            
            do {
                try result()
                self.bajaSpinner.stopAnimating()
                self.bajaButton.enabled = true
                
            } catch {
                self.bajaSpinner.stopAnimating()
                self.tarjetaViewController?.reloadTarjeta()
            }
        }
    }
}
