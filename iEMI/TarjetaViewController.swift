//
//  TarjetaViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/17/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

struct Tarjeta {
    var TarNro = "", TarAno = "", TarSerie = ""
}

class TarjetaViewController: TabBarIconFixerViewController {
    
    @IBOutlet weak var numeroDeTarjetaLabel: UILabel!
    @IBOutlet weak var cerrarButton: UIButton!
    
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var horaInicioLabel: UILabel!
    @IBOutlet weak var horaFinLabel: UILabel!
    @IBOutlet weak var duracionLabel: UILabel!
    @IBOutlet weak var estadoLabel: UILabel!
    @IBOutlet weak var direccionSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var fechaSpinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var tarjeta = Tarjeta()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let parent = self.parentViewController?.isKindOfClass(BajaViewController) {
            self.cerrarButton.hidden = true
        }
        
        self.reloadTarjeta()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTarjeta() {
    
        self.numeroDeTarjetaLabel.text = self.tarjeta.TarNro
        
        //TODO: mostrar toda la info de la tarjeta
        
        self.direccionLabel.text = ""
        self.fechaLabel.text = ""
        self.horaInicioLabel.text = ""
        self.horaFinLabel.text = ""
        self.duracionLabel.text = ""
        self.estadoLabel.text = ""
        
        self.loadDireccion(self.tarjeta)
        self.loadHorarios(self.tarjeta)
        
    }

    @IBAction func cerrarButtonTouched(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    // MARK: - service calls
    
    let REST_SERVICE_URL = "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/"
    
    func loadDireccion(tar: Tarjeta) {
        
        self.direccionSpinner.startAnimating()
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesTarjetas_Tarjetas_Section_Ubicacion?TarNro="+tar.TarNro+"&TarAno="+tar.TarAno+"&TarSerie="+tar.TarSerie)!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            
            if error != nil {
               self.showDireccionError(error)
            }else {
                var err: NSError?
                if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [String:AnyObject] {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.direccionLabel.text = jsonData["TarAddress"] as? String
                        self.direccionSpinner.stopAnimating()
                    })
                    
                }else {
                    self.showDireccionError(err)
                }
            }
        }
        task.resume()
    }
    
    func loadHorarios(tar: Tarjeta) {
        self.fechaSpinner.startAnimating()
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesTarjetas_Tarjetas_Section_Horario?TarNro="+tar.TarNro+"&TarAno="+tar.TarAno+"&TarSerie="+tar.TarSerie)!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            
            if error != nil {
                self.showHorariosError(error)
            }else {
                var err: NSError?
                if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [String:AnyObject] {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        //mas chanchada, alto refactoring needed :P
                        
                        self.fechaLabel.text = jsonData["TarFecha"] as? String
                        var horaIni = jsonData["TarHoraIni"] as! NSString
                        self.horaInicioLabel.text = horaIni.substringFromIndex(11) + " hs"
                        
                        var horaFin = jsonData["TarHoraFin"] as! NSString
                        self.horaFinLabel.text = horaFin.substringFromIndex(11) + " hs"
                        
                        var tiempo = jsonData["TarTiempo"] as! String
                        var horas = tiempo.toInt()!/60 as Int
                        var minutos = tiempo.toInt()! % 60
                        
                        self.duracionLabel.text = String("\(horas) hs \(minutos) min")
                        
                        self.estadoLabel.text = jsonData["TarHoraFin"] as? String == "0000-00-00T00:00:00" ? "estacionado": "cerrado"
                        self.fechaSpinner.stopAnimating()
                    })
                    
                }else {
                    self.showHorariosError(err)
                }
            }
        }
        task.resume()
    }
    
    func showHorariosError(error: NSError?) {
         println("Error: \(error)")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.fechaSpinner.stopAnimating()
        })
    }
    
    func showDireccionError(error: NSError?) {
        println("Error: \(error)")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.direccionSpinner.stopAnimating()
        })
    }

}
