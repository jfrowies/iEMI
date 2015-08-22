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
        
//        self.tarjeta = Tarjeta()
        
        self.loadTarjeta()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func bajaButtonTouched(sender: UIButton) {
//        self.bajaTarjeta(self.tarjeta)
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
        
//        var session = NSURLSession.sharedSession()
//        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "BuscaTarjeta")!)
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        var params = ["Tarchapa":self.patente()] as Dictionary<String, String>
//        var err: NSError?
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
//        
//        let task = session.dataTaskWithRequest(request) { data, response, error -> Void in
//            
//            if error != nil {
//                self.showError(error!.description)
//                return
//            }
//            
//            var responseDataError: NSError?
//            if let responseData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &responseDataError) as! [String:AnyObject]? {
//                
//                if error != nil {
//                    self.showError(error!.description)
//                    return
//                }
//                
//                if let messages = responseData["Messages"] as? [[String : AnyObject]] {
//                    
//                    if let m = messages.first {
//                        let d = m["Description"] as! String!
//                        self.showError(d)
//                        return
//                    }
//                }
//                    
//                self.tarjeta.TarAno = String(responseData["Tarano"] as! Int!)
//                self.tarjeta.TarNro = responseData["Tarnro"]as! String!
//                self.tarjeta.TarSerie = responseData["TarSerie"] as! String!
//                    
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.tarjetaViewController?.tarjeta = self.tarjeta
//                    self.tarjetaViewController?.reloadTarjeta()
//                    self.loadingView.hidden = true
//                    self.bajaButton.enabled = true
//                })
//            }
//        }
//        task.resume()
    }
    
    func bajaTarjeta() {
        
//        self.bajaButton.enabled = false
//        self.bajaSpinner.startAnimating()
//        
//        var session = NSURLSession.sharedSession()
//        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "CloseTarjeta")!)
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        var params = ["TarSerie":tar.TarSerie,"TarNro":tar.TarNro,"TarAno":tar.TarAno] as Dictionary<String, String>
//        var err: NSError?
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
//        
//        let task = session.dataTaskWithRequest(request) {data, response, error -> Void in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                self.bajaSpinner.stopAnimating()
//                
//                if error != nil {
//                    self.bajaButton.enabled = true
//                } else {
//                    self.tarjetaViewController?.reloadTarjeta()
//                }
//            })
//        }
//        task.resume()

    }
}
