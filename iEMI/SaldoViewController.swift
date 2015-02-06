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
