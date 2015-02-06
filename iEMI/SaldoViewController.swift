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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        reloadData(patente: self.patente())
       
    }
    
    func patente() ->String {
        return NSUserDefaults.standardUserDefaults().stringForKey("patenteKey")!
    }
    
    func reloadData(#patente: String) {
        
        self.loadingSpinner.startAnimating()
        self.refreshButton.enabled = false
        
        var session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/WorkWithDevicesEMCredito_EMCredito_List?fmt=json&CreditoChapa="+patente+"&gxid=2")!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        println("Resquest: \(request)")
        
        var task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
            println("Response: \(response)")
            
            if let jsonSaldo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? [String:String] {
                self.updateSaldo(jsonSaldo["Creditosaldo"]! + " $")
            }else {
                self.updateSaldo("Unknown")
            }
            
        }
        task.resume()
    }
    
    func updateSaldo(saldo:String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.refreshButton.enabled = true
            self.loadingSpinner.stopAnimating()
            self.saldoLabel.text = saldo
        })
    }

    @IBAction func refreshButtonTouched(sender: UIButton) {
        reloadData(patente: self.patente())
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
        
    }
    
    
    
}
