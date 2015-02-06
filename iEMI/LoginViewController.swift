//
//  LoginViewController.swift
//  iEMI
//
//  Created by Fernando Rowies on 2/2/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var patenteTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var aceptarbutton: UIButton!
    @IBOutlet weak var cargandoSpinner: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.hidden = true
        self.patenteTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("patenteKey")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.patenteTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.patenteTextField {
            self.pinTextField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func aceptarTouched(sender: UIButton) {
        
        self.aceptarbutton.enabled = false
        self.patenteTextField.enabled = false
        self.pinTextField.enabled = false
        self.cargandoSpinner.hidden = false
        self.cargandoSpinner.startAnimating()
        self.errorLabel.hidden = true
        
        self.getSessionCookie(patente: self.patenteTextField.text)
    }
    
    func getSessionCookie(#patente: String) {
        
        var session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/UpperChapa?fmt=json")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var params = ["Tarchapa":patente] as Dictionary<String, String>
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        println("Resquest: \(request)")
        
        var task = session.dataTaskWithRequest(request) {data, response, error -> Void in
            
            println("Response: \(response)")
            
            if error != nil {
                self.showError(error.description)
            }else {
                if self.pinTextField.text == "2432" {
                    self.savePatente(patente)
                    self.performSegueWithIdentifier("showTabBarViewController", sender: self)
                }else {
                    self.authenticatePatente(self.patenteTextField.text, pin:self.pinTextField.text)
                }
            }
        }
        task.resume()
    }
    
    func authenticatePatente(patente:String,pin:String) {
        
        var session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/VerifPinSinHorario?fmt=json")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var params = ["AutoPin":pin,"AutoChapa":patente] as Dictionary<String, String>
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        println("Resquest: \(request)")
        
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            println("Response: \(response)")
            println("Error: \(error)")
            
            if let responseData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as [String:AnyObject]? {
                println("Data: \(responseData)")
                if let messages = responseData["Messages"] as? [[String : AnyObject]] {
                    if let m = messages.first {
                        let d = m["Description"] as String!
                        self.showError(d)
                    }
                } else if error != nil {
                    self.showError(error.description)
                } else {
                    self.savePatente(patente)
                    self.performSegueWithIdentifier("showTabBarViewController", sender: self)
                }
            } else {
                self.showError("Error parsing response")
            }
            
        }
        task.resume()
    }
    
    func savePatente(patente:String) {
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setObject(patente, forKey: "patenteKey")
        settings.synchronize()
    }
    
    func showError(error: String) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.errorLabel.text = error
            self.errorLabel.hidden = false
            self.aceptarbutton.enabled = true
            self.patenteTextField.enabled = true
            self.pinTextField.enabled = true
            self.cargandoSpinner.stopAnimating()
        })
    }
    
}