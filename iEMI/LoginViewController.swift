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
    
    let service: LoginService = LoginEMIService()
    
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
        self.patenteTextField.becomeFirstResponder()
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
        
        self.getSessionCookie(patente: self.patenteTextField.text!) { () -> Void in
            self.authenticatePatente(self.patenteTextField.text!, pin: self.pinTextField.text!)
        }
    }
    
    //MARK: - Service calls
    
    let defaultErrorDescription = NSLocalizedString("Unknown error.", comment: "default error message")
        
    func getSessionCookie(patente patente: String, completion: (Void -> Void)) {
        
        service.getSessionCookie(licensePlate: patente) { (result) -> Void in
            do {
                try result()
                completion()
            } catch  ServiceError.RequestFailed(let errorDescription){
                self.showError(errorDescription!)
            } catch  {
                self.showError(self.defaultErrorDescription)
            }
        }
    }
    
    func authenticatePatente(patente:String,pin:String) {
        
        service.authenticate(licensePlate: patente, password: pin) { (result) -> Void in
            do {
                if try result() {
                    self.savePatente(patente)
                    self.performSegueWithIdentifier("showTabBarViewController", sender: self)
                }
            } catch ServiceError.ResponseErrorMessage(let errorMessage) {
                self.showError(errorMessage!)
            } catch ServiceError.RequestFailed(let errorDescription) {
                self.showError(errorDescription!)
            } catch {
                self.showError(self.defaultErrorDescription)
            }
        }
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