//
//  SaldoViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/6/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class SaldoViewController: TabBarIconFixerViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    override func iconName() -> String { return "saldo" }

    var refreshControl: UIRefreshControl!
    var tableElements = [Transaction]()
    var tarjetaSeleccionada = Tarjeta()
    var sectionItemCount = [Int]()
    var sectionFirstItem = [Int]()
    var saldo = 0.0
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsetsMake(48, 0, 0, 0)
        
        reloadData(patente: self.patente())
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Tire para recargar")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject) {
        reloadData(patente: self.patente())
    }
    
    //MARK: -
    
    func patente() ->String {
        return NSUserDefaults.standardUserDefaults().stringForKey("patenteKey")!
    }
    
    
    func reloadData(patente patente: String) {
        
        self.loadingSpinner.startAnimating()
        
        self.reloadSaldoData(patente: patente)
        self.reloadTableData(patente: patente, count: 5)
        
    }
    
    func reloadTableData(patente patente: String, count: Int) {

        var newTableElements = [Transaction]()
        
        self.loadRecargas(patente: patente, count: count) { (creditos: [Credit]) -> Void in
            
            for credito in creditos {
                newTableElements.append(credito)
            }
            
           self.sortElements(&newTableElements)
            
            self.loadConsumos(patente: patente, desdeHoraIni: newTableElements.last!.timestamp) { (consumos: [Consumo]) -> Void in
                
                for consumo in consumos {
                    newTableElements.append(consumo)
                }
                
                self.sortElements(&newTableElements)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.tableElements = newTableElements
                    self.tableView.reloadData()
                })
            }
        }
    }

    func updateSaldo(saldo:String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.loadingSpinner.stopAnimating()
            self.saldoLabel.text = saldo
            self.refreshControl.endRefreshing()
        })
    }
    
    func sortElements(inout elements:[Transaction]) {
        
        elements.sortInPlace({ (mov1: Transaction, mov2: Transaction) -> Bool in
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
        var newSaldo = self.saldo
        for mov: Transaction in self.tableElements {
            var timestamp: String = mov.timestamp
            let subDate = timestamp.substringToIndex(advance(timestamp.startIndex, 10))
            if (!(date == subDate)) {
                date = subDate
                self.sectionItemCount.append(0)
                self.sectionFirstItem.append(index)
                sections++
            }
            
            mov.saldo = String(format: "%.2f $", newSaldo)
            if (mov.isKindOfClass(Consumo))
            {
                let importe = (mov as! Consumo).importe
                newSaldo += (importe! as NSString).doubleValue
            }
            if (mov.isKindOfClass(Credit))
            {
                let importe = (mov as! Credit).importe
                newSaldo -= (importe! as NSString).doubleValue
            }
            
            self.sectionItemCount[sections - 1] = self.sectionItemCount[sections - 1] + 1
            index++
        }
        return sections
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let mov = self.tableElements[self.sectionFirstItem[section]];
        
        var timestamp: String = mov.timestamp
        let subDate = timestamp.substringToIndex(advance(timestamp.startIndex, 10))
        
        let nsDate = NSDate(dateString: subDate)
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        return formatter.stringFromDate(nsDate)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionItemCount[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let movimiento = self.tableElements[self.sectionFirstItem[indexPath.section] + indexPath.row]
        
        if movimiento.isKindOfClass(Credit) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("creditoCell", forIndexPath: indexPath) as! CreditoTableViewCell
            cell.credito = movimiento as! Credit
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
            let dvc = segue.destinationViewController as! TarjetaViewController
            dvc.tarjeta = self.tarjetaSeleccionada
        }
    }
    
    //MARK: - Service calls
    
    func reloadSaldoData(patente patente: String) {
        
//        let session = NSURLSession.sharedSession()
//        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesEMCredito_EMCredito_List?CreditoChapa="+patente)!)
//        
//        request.HTTPMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
//            
//            if let jsonSaldo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? [String:String] {
//                let saldoValue = jsonSaldo["Creditosaldo"]!
//                self.updateSaldo(saldoValue + " $")
//                self.saldo = (saldoValue as NSString).doubleValue
//            }else {
//                self.updateSaldo("Unknown")
//                self.saldo = 0.0
//            }
//            
//        }
//        task.resume()
    }
    
    func loadRecargas(patente patente: String, count: Int, completion: ([Credit] -> Void)) {
        
//        let session = NSURLSession.sharedSession()
//        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesEMCredito_EMCredito_List_Grid?CreditoChapa="+patente+"&count="+String(count))!)
//        request.HTTPMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
//            
//            if error != nil {
//                self.showTableError(error)
//                return
//            }
//            
//            var err: NSError?
//            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:String]] {
//                //crear objetos credito
//                var creditoArray = [Credit]()
//                for creditoJson in jsonData {
//                    creditoArray.append(Credit(json: creditoJson))
//                }
//                completion(creditoArray)
//            }else {
//                self.showTableError(err)
//            }
//            
//        }
//        task.resume()
    }
    
    func loadConsumos(patente patente: String, desdeHoraIni: String, completion: ([Consumo] -> Void)) {
        
//        let session = NSURLSession.sharedSession()
//        
//        let request = NSMutableURLRequest(URL: NSURL(string: self.REST_SERVICE_URL + "WorkWithDevicesTarjetas_UltimosConsumos_List_Grid?TarChapa="+patente+"&Tarhoraini="+desdeHoraIni)!)
//        request.HTTPMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
//            
//            if error != nil {
//                self.showTableError(error)
//                return
//            }
//            
//            var err: NSError?
//            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:AnyObject]] {
//                
//                var consumosArray = [Consumo]()
//                for consumoJson in jsonData {
//                    consumosArray.append(Consumo(json: consumoJson))
//                }
//                completion(consumosArray)
//                
//            }else {
//                self.showTableError(err)
//            }
//            
//        }
//        task.resume()
        
    }
    
    func showTableError(error: NSError?) {
        print("Error: \(error)")
        //TODO: show error feedback
    }
    
}
