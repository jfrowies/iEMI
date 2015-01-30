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
        var session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/UpperChapa?fmt=json")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var params = ["Tarchapa":"gsv024"] as Dictionary<String, String>
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
       
//        request.addValue("Spanish", forHTTPHeaderField: "GeneXus-Language")
//        request.addValue("SmartDevice Application", forHTTPHeaderField: "GeneXus-Agent")
//        request.addValue("es-ES,es", forHTTPHeaderField: "Accept-Language")
//        request.addValue("iOS", forHTTPHeaderField: "DeviceOSName")
//        request.addValue("80", forHTTPHeaderField: "DeviceOSVersion")
//        request.addValue("3a6a4fd2-25b2-352a-80f2-a5e796f59d41", forHTTPHeaderField: "DeviceId")
//        request.addValue("354987052282506", forHTTPHeaderField: "DeviceNetworkId")
//        request.addValue("21", forHTTPHeaderField: "Content-Length")

//        request.addValue("w1.logo-sa.com.ar:8080", forHTTPHeaderField: "Host")
//        request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
//        request.addValue("Apache-HttpClient/UNAVAILABLE (java 1.4)", forHTTPHeaderField: "User-Agent")
        
        println("Resquest: \(request)")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            
            var session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: NSURL(string: "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/UpperChapa?fmt=json")!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var params = ["Tarchapa":"gsv024"] as Dictionary<String, String>
            var err: NSError?
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
            
//            
//            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("Body: \(strData)")
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
//            if(err != nil) {
//                println(err!.localizedDescription)
//                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                println("Error could not parse JSON: '\(jsonStr)'")
//            }
//            else {
//                // The JSONObjectWithData constructor didn't return an error. But, we should still
//                // check and make sure that json has a value using optional binding.
//                if let parseJSON = json {
//                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
//                    var success = parseJSON["success"] as? Int
//                    println("Succes: \(success)")
//                }
//                else {
//                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
//                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                    println("Error could not parse JSON: \(jsonStr)")
//                }
//            }
            
            
        })
        
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

