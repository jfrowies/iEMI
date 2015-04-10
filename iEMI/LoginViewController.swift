//
//  LoginViewController.swift
//  iEMI
//
//  Created by Fernando Rowies on 2/2/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class LoginViewController: TabBarIconFixerViewController, UITextFieldDelegate {
    
    @IBOutlet weak var patenteTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var aceptarbutton: UIButton!
    @IBOutlet weak var cargandoSpinner: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.hidden = true
        self.patenteTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("patenteKey")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.errorLabel.hidden = true
        self.aceptarbutton.enabled = true
        self.patenteTextField.enabled = true
        self.pinTextField.enabled = true
        self.cargandoSpinner.stopAnimating()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.patenteTextField.becomeFirstResponder()
        
        self.getSessionCookie(patente: self.patenteTextField.text)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.patenteTextField {
            self.pinTextField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    //MARK: - IBActions
    
    @IBAction func aceptarTouched(sender: UIButton) {
        
        self.aceptarbutton.enabled = false
        self.patenteTextField.enabled = false
        self.pinTextField.enabled = false
        self.cargandoSpinner.hidden = false
        self.cargandoSpinner.startAnimating()
        self.errorLabel.hidden = true
        
        self.getSessionCookie(patente: self.patenteTextField.text)
    }
    
    //MARK: - Service calls
    
    let REST_SERVICE_URL = "http://w1.logo-sa.com.ar:8080/EstacionamientoV2/rest/"
    
    func getSessionCookie(#patente: String) {
        
        var session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "UpperChapa")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var params = ["Tarchapa":patente] as Dictionary<String, String>
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        let task = session.dataTaskWithRequest(request) {data, response, error -> Void in
            
            if error != nil {
                self.showError(error.localizedDescription)
            }else {
                // hack
                self.performSegueWithIdentifier("showTabBarViewController", sender: self)

                /*if self.pinTextField.text == "2432" {
                    self.savePatente(patente)
                    self.performSegueWithIdentifier("showTabBarViewController", sender: self)
                } else {
                    self.authenticatePatente(self.patenteTextField.text, pin:self.pinTextField.text)
                }*/
            }
        }
        task.resume()
    }
    
    func authenticatePatente(patente:String,pin:String) {
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: REST_SERVICE_URL + "VerifPinSinHorario")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["AutoPin":pin,"AutoChapa":patente] as Dictionary<String, String>
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in

            if let responseData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as [String:AnyObject]? {

                if let messages = responseData["Messages"] as? [[String : AnyObject]] {
                    if let m = messages.first {
                        let d = m["Description"] as String!
                        self.showError(d)
                    }
                } else if error != nil {
                    self.showError(error.localizedDescription)
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
    
    //MARK: -
    
    func savePatente(patente:String) {
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setObject(patente.uppercaseString, forKey: "patenteKey")
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