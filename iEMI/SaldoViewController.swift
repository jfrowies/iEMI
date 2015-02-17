//
//  SaldoViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/6/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class SaldoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var tableElements = [Movimiento]()
    var tarjetaSeleccionada = Tarjeta()
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        
        reloadData(patente: self.patente())

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    
    func patente() ->String {
        return NSUserDefaults.standardUserDefaults().stringForKey("patenteKey")!
    }
    
    
    func reloadData(#patente: String) {
        
        self.loadingSpinner.startAnimating()
        self.refreshButton.enabled = false
        
        self.reloadSaldoData(patente: patente)
        self.reloadTableData(patente: patente, count: 5)
        
    }
    
    func reloadTableData(#patente: String, count: Int) {
        
        //show spinner on table
        self.tableElements.removeAll(keepCapacity: false)
        
        self.loadRecargas(patente: patente, count: count) { (creditos: [Credito]) -> Void in
            
            for credito in creditos {
                self.tableElements.append(credito)
            }
            
            self.sortTableElements()
            
            self.loadConsumos(patente: patente, desdeHoraIni: self.tableElements.last!.timestamp!) { (consumos: [Consumo]) -> Void in
                
                for consumo in consumos {
                    self.tableElements.append(consumo)
                }
                
                self.sortTableElements()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }

    func updateSaldo(saldo:String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.refreshButton.enabled = true
            self.loadingSpinner.stopAnimating()
            self.saldoLabel.text = saldo
        })
    }
    
    func sortTableElements() {
        self.tableElements.sort({ (mov1: Movimiento, mov2: Movimiento) -> Bool in
            if mov1.timestamp > mov2.timestamp {
                return true
            }else if mov1.timestamp == mov2.timestamp {
                if mov1.isKindOfClass(Consumo) {
                    return true
                }else {
                    return false
                }
            } else {
                return false
            }
        })
    }
    
    //MARK: - IBAction

    @IBAction func refreshButtonTouched(sender: UIButton) {
        reloadData(patente: self.patente())
    }
    
    //MARK: - UITableViewDelegate implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableElements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let movimiento = self.tableElements[indexPath.row]
        
        if movimiento.isKindOfClass(Credito) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("creditoCell", forIndexPath: indexPath) as CreditoTableViewCell
            cell.credito = self.tableElements[indexPath.row] as Credito
            return cell
        }
        
        if movimiento.isKindOfClass(Consumo) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("consumoCell", forIndexPath: indexPath) as ConsumoTableViewCell
            cell.consumo = self.tableElements[indexPath.row] as Consumo
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        var tar = Tarjeta()
        
        if let consumo = self.tableElements[indexPath.row] as? Consumo {
            tar.TarNro = consumo.tarNro!
            tar.TarAno = consumo.tarAno!
            tar.TarSerie = consumo.tarSerie!
            self.tarjetaSeleccionada = tar
        }else{
            return nil
        }

        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTarjeta" {
            var dvc = segue.destinationViewController as TarjetaViewController
            dvc.tarjeta = self.tarjetaSeleccionada
        }
    }
    
    //MARK: - Service calls
    
    let REST_SERVICE_URL = "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/"
    
    func reloadSaldoData(#patente: String) {
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesEMCredito_EMCredito_List?CreditoChapa="+patente)!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            
            if let jsonSaldo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? [String:String] {
                self.updateSaldo(jsonSaldo["Creditosaldo"]! + " $")
            }else {
                self.updateSaldo("Unknown")
            }
            
        }
        task.resume()
    }
    
    func loadRecargas(#patente: String, count: Int, completion: ([Credito] -> Void)) {
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesEMCredito_EMCredito_List_Grid?CreditoChapa="+patente+"&count="+String(count))!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            
            var err: NSError?
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:String]] {
                //crear objetos credito
                var creditoArray = [Credito]()
                for creditoJson in jsonData {
                    creditoArray.append(Credito(json: creditoJson))
                }
                completion(creditoArray)
            }else {
                println("Error: \(err)")
            }
            
        }
        task.resume()
    }
    
    func loadConsumos(#patente: String, desdeHoraIni: String, completion: ([Consumo] -> Void)) {
        
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.REST_SERVICE_URL + "WorkWithDevicesTarjetas_UltimosConsumos_List_Grid?TarChapa="+patente+"&Tarhoraini="+desdeHoraIni)!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            var err: NSError?
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:AnyObject]] {
                
                var consumosArray = [Consumo]()
                for consumoJson in jsonData {
                    consumosArray.append(Consumo(json: consumoJson))
                }
                completion(consumosArray)
                
            }else {
                println("Error: \(err)")
            }
            
        }
        task.resume()
        
    }
    
}
