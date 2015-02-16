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
    
    var tableElements = [AnyObject]() //esto deberia ser de tipo "movimiento" que seria una interfaz con fecha y tipo de movimiento para porder agregar recargas y consumos
    
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
    
    //MARK: - Service calls
    
    let REST_SERVICE_URL = "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/"
    
    func reloadData(#patente: String) {
        
        self.loadingSpinner.startAnimating()
        self.refreshButton.enabled = false
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesEMCredito_EMCredito_List?CreditoChapa="+patente)!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            
            if let jsonSaldo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? [String:String] {
                self.updateSaldo(jsonSaldo["Creditosaldo"]! + " $")
                self.reloadTableData(patente: patente, count: 10)
            }else {
                self.updateSaldo("Unknown")
            }
            
        }
        task.resume()
    }
    
    func reloadTableData(#patente: String, count: Int) {
        
        //show spinner on table
        self.tableElements.removeAll(keepCapacity: false)
        
        self.loadRecargas(patente: patente, count: count) { (creditos: [Credito]) -> Void in
            
            for credito in creditos {
                self.tableElements.append(credito)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
        self.loadConsumos(patente: patente, count: count*2) { (consumos: [Consumo]) -> Void in
            
            for consumo in consumos {
                self.tableElements.append(consumo)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }

    }
    
    func loadRecargas(#patente: String, count: Int, completion: ([Credito] -> Void)) {
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesEMCredito_EMCredito_List_Grid?CreditoChapa="+patente+"&count="+String(count))!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            
            var err: NSError?
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:String]] {
                println("Recargas Data: \(jsonData)")
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
    
    func loadConsumos(#patente: String, count: Int, completion: ([Consumo] -> Void)) {
        
        let session = NSURLSession.sharedSession()
                
        let request = NSMutableURLRequest(URL: NSURL(string: self.REST_SERVICE_URL + "WorkWithDevicesTarjetas_UltimosConsumos_List_Grid?TarChapa="+patente+"&count="+String(count))!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        println("Resquest: \(request)")
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            println("Response: \(response)")
            var err: NSError?
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:AnyObject]] {
                println("Consumos Data: \(jsonData)")
                //crear objetos consumo
                //crear objetos credito
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
    
    //MARK: -
    
    func updateSaldo(saldo:String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.refreshButton.enabled = true
            self.loadingSpinner.stopAnimating()
            self.saldoLabel.text = saldo
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

        let movimiento : AnyObject = self.tableElements[indexPath.row]
        
        
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
    
}
