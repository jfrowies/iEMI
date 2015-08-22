//
//  TarjetaViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/17/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class TarjetaViewController: TabBarIconFixerViewController {
    
    @IBOutlet weak var cerrarButton: UIButton!
    
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var horaInicioLabel: UILabel!
    @IBOutlet weak var horaFinLabel: UILabel!
    @IBOutlet weak var duracionLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    @IBOutlet weak var direccionSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var fechaSpinner: UIActivityIndicatorView!
    
    let service: ParkingInformationService = ParkingInformationEMIService()
    
    var tarjeta: Parking?

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = self.parentViewController?.isKindOfClass(BajaViewController) {
            self.cerrarButton.hidden = true
        }
        
        self.reloadTarjeta()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTarjeta() {
                
        self.direccionLabel.text = ""
        self.fechaLabel.text = ""
        self.horaInicioLabel.text = ""
        self.horaFinLabel.text = ""
        self.duracionLabel.text = ""
        self.estadoLabel.text = ""
        
        self.loadDireccion()
        self.loadHorarios()
    }

    @IBAction func cerrarButtonTouched(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    // MARK: - service calls
    
    func loadDireccion() {
        
        guard let currentParking = self.tarjeta else {
            return
        }
        
        self.direccionSpinner.startAnimating()
        
        service.location(currentParking) { [unowned self] (result) -> Void in
            
            do {
                let parkingLocation = try result()
                self.direccionLabel.text = parkingLocation.fullAddress
                self.direccionSpinner.stopAnimating()
                
            } catch let error{
                
                print("Error: \(error)")
                self.direccionSpinner.stopAnimating()
            }
        }
    }
    
    func loadHorarios() {
        
        guard let currentParking = self.tarjeta else {
            return
        }
        
        self.fechaSpinner.startAnimating()

        
        service.time(currentParking) { [unowned self] (result) -> Void in
            
            do {
                let parkingTime = try result()
                
                self.fechaLabel.text = parkingTime.date
                
                let horaIni = parkingTime.startTime! as NSString
                self.horaInicioLabel.text = horaIni.substringFromIndex(11) + " hs"

                let horaFin = parkingTime.endTime! as NSString
                self.horaFinLabel.text = horaFin.substringFromIndex(11) + " hs"

                let tiempo = parkingTime.parkingTime!
                let horas = Int(tiempo)!/60 as Int
                let minutes = Int(tiempo)! % 60

                self.duracionLabel.text = String("\(horas) hs \(minutes) min")

                self.estadoLabel.text = parkingTime.endTime == "0000-00-00T00:00:00" ? "estacionado": "cerrado"
                self.fechaSpinner.stopAnimating()

            } catch let error{
                
                print("Error: \(error)")
                self.fechaSpinner.stopAnimating()
              
            }
        }

    }
    
}
