//
//  ViewController.swift
//  iEMI
//
//  Created by Fernando Rowies on 1/29/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var saldoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////
        var session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/UpperChapa?fmt=json")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var params = ["Tarchapa":"lxi369"] as Dictionary<String, String>
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
       
        
        println("Resquest: \(request)")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("Response: \(response)")
            
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////
            var session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: NSURL(string: "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/WorkWithDevicesEMCredito_EMCredito_List?fmt=json&CreditoChapa=lxi369&gxid=2")!)
            
            request.HTTPMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            println("Resquest: \(request)")
            
            var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                println("Response: \(response)")
                
                let jsonSaldo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as [String:String]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.saldoLabel.text = jsonSaldo["Creditosaldo"]
                })
                
            });
            task.resume()
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////
//            var session = NSURLSession.sharedSession()
//            let request = NSMutableURLRequest(URL: NSURL(string: "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/VerifiPinSinHorario?fmt=json")!)
//            request.HTTPMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            var params = ["AutoPin":"2812","AutoChapa":"gsv024"] as Dictionary<String, String>
//            var err: NSError?
//            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
//            
//            println("Resquest: \(request)")
//            
//            var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                
//                println("Response: \(response)")
//                
//                
//               
//                
//            });
//            task.resume()
            
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

