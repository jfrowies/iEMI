//
//  SaldoViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/6/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class SaldoViewController: TabBarIconFixerViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingTableSpinner: UIActivityIndicatorView!
    @IBOutlet weak var feedbackTableLabel: UILabel!
    @IBOutlet weak var loadingtableView: UIView!
    
    override func iconName() -> String { return "saldo" }
        
    var tableElements = [Movimiento]()
    var tarjetaSeleccionada = Tarjeta()
    var sectionItemCount = [Int]()
    var sectionFirstItem = [Int]()
    
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
        
        self.loadingtableView.alpha = 1.0
        self.loadingTableSpinner.startAnimating()
        self.feedbackTableLabel.text = "cargando"
        
        self.tableElements.removeAll(keepCapacity: false)
        
        self.loadRecargas(patente: patente, count: count) { (creditos: [Credito]) -> Void in
            
            for credito in creditos {
                self.tableElements.append(credito)
            }
            
            self.sortTableElements()
            
            self.loadConsumos(patente: patente, desdeHoraIni: self.tableElements.last!.timestamp) { (consumos: [Consumo]) -> Void in
                
                for consumo in consumos {
                    self.tableElements.append(consumo)
                }
                
                self.sortTableElements()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.loadingtableView.alpha = 0.0
                    })
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        self.sectionItemCount.removeAll(keepCapacity: false)
        self.sectionFirstItem.removeAll(keepCapacity: false)
        var sections = 0;
        var date: String = "";
        var index: Int = 0;
        for mov: Movimiento in self.tableElements {
            var timestamp: String = mov.timestamp
            var subDate = timestamp.substringToIndex(advance(timestamp.startIndex, 10))
            if (!(date == subDate)) {
                date = subDate
                self.sectionItemCount.append(0)
                self.sectionFirstItem.append(index)
                sections++
            }
            self.sectionItemCount[sections - 1] = self.sectionItemCount[sections - 1] + 1
            index++
        }
        return sections
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let mov = self.tableElements[self.sectionFirstItem[section]];
        
        var timestamp: String = mov.timestamp
        var subDate = timestamp.substringToIndex(advance(timestamp.startIndex, 10))
        return subDate
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionItemCount[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let movimiento = self.tableElements[self.sectionFirstItem[indexPath.section] + indexPath.row]
        
        if movimiento.isKindOfClass(Credito) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("creditoCell", forIndexPath: indexPath) as! CreditoTableViewCell
            cell.credito = movimiento as! Credito
            return cell
        }
        
        if movimiento.isKindOfClass(Consumo) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("consumoCell", forIndexPath: indexPath) as! ConsumoTableViewCell
            cell.consumo = movimiento as! Consumo
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
            var dvc = segue.destinationViewController as! TarjetaViewController
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
            
            if error != nil {
                self.showTableError(error)
                return
            }
            
            var err: NSError?
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:String]] {
                //crear objetos credito
                var creditoArray = [Credito]()
                for creditoJson in jsonData {
                    creditoArray.append(Credito(json: creditoJson))
                }
                completion(creditoArray)
            }else {
                self.showTableError(err)
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
            
            if error != nil {
                self.showTableError(error)
                return
            }
            
            var err: NSError?
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:AnyObject]] {
                
                var consumosArray = [Consumo]()
                for consumoJson in jsonData {
                    consumosArray.append(Consumo(json: consumoJson))
                }
                completion(consumosArray)
                
            }else {
                self.showTableError(err)
            }
            
        }
        task.resume()
        
    }
    
    func showTableError(error: NSError?) {
        println("Error: \(error)")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.loadingTableSpinner.stopAnimating()
            self.feedbackTableLabel.text = error?.localizedDescription
        })
    }
    
}
