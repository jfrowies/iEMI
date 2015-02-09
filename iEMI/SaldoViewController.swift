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
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesEMCredito_EMCredito_List?fmt=json&CreditoChapa="+patente)!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        println("Resquest: \(request)")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
//            println("Response: \(response)")
            
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
        
        self.loadRecargas(patente: patente, count: count) { ([[String:String]]) -> Void in
            //guardo el resultado y hago la otra llamada
            
            self.loadConsumos(patente: patente, count: count) { ([[String:String]]) -> Void in
                
            }
            
        }

    }
    
    func loadRecargas(#patente: String, count: Int, completion: ([[String:String]] -> Void)) {
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "WorkWithDevicesEMCredito_EMCredito_List_Grid?fmt=json&CreditoChapa="+patente+"&count="+String(count))!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //        println("Resquest: \(request)")
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            
            //            println("Response: \(response)")
            
            var err: NSError?
            
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:String]] {
                println("Data: \(jsonData)")
                completion(jsonData)
            }else {
                println("Error: \(err)")
            }
            
        }
        task.resume()
    }
    
    func loadConsumos(#patente: String, count: Int, completion: ([[String:String]] -> Void)) {
        
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "VerUltFechaTar?fmt=json")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params = ["TarChapa":patente,"Cant":String(count)] as Dictionary<String, String>
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        println("Resquest: \(request)")
        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            println("Response: \(response)")
            var err: NSError?
            if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [String:String] {
                println("Data: \(jsonData)")
                
                
                let request = NSMutableURLRequest(URL: NSURL(string: self.REST_SERVICE_URL + "WorkWithDevicesTarjetas_UltimosConsumos_List_Grid?TarChapa="+patente+"&Tarhoraini=0000-00-00T00:00:00&fmt=json&count="+String(count))!)
                
                request.HTTPMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               
                println("Resquest: \(request)")
                let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
                    println("Response: \(response)")
                    var err: NSError?
                    if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as? [[String:String]] {
                        println("Data: \(jsonData)")
                        
                    }else {
                        println("Error: \(err)")
                    }
                    
                }
                task.resume()
                
                
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
        //TODO
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO
        return UITableViewCell()
    }
    
}
