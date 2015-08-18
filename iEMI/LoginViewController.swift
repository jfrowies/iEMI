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
    let licensePlate = LicensePlate()
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentLicensePlate = self.licensePlate.currentLicensePlate {
            self.patenteTextField.text = currentLicensePlate
            self.showLoadingUI(true)
             self.getSessionCookie(patente: self.patenteTextField.text!) { [unowned self] () -> Void in
                self.performSegueWithIdentifier("showTabBarViewController", sender: self)
            }
        } else {
            self.showLoadingUI(false)
            self.patenteTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func showLoadingUI(loading:Bool) {
        if loading {
            self.aceptarbutton.enabled = false
            self.patenteTextField.enabled = false
            self.pinTextField.enabled = false
            self.cargandoSpinner.hidden = false
            self.cargandoSpinner.startAnimating()
            self.errorLabel.hidden = true
        } else {
            self.aceptarbutton.enabled = true
            self.patenteTextField.enabled = true
            self.pinTextField.enabled = true
            self.cargandoSpinner.stopAnimating()
            self.errorLabel.hidden = true
        }
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
        
        self.showLoadingUI(true)
        
        self.getSessionCookie(patente: self.patenteTextField.text!) { [unowned self] () -> Void in
            self.authenticatePatente(self.patenteTextField.text!, pin: self.pinTextField.text!) { [unowned self]  () -> Void in
                self.performSegueWithIdentifier("showTabBarViewController", sender: self)
            }
        }
    }
    
    //MARK: - Service calls
    
    let defaultErrorDescription = NSLocalizedString("Unknown error.", comment: "default error message")
        
    func getSessionCookie(patente patente: String, completion: (Void -> Void)) {
        
        service.getSessionCookie(licensePlate: patente) { [unowned self]  (result) -> Void in
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
    
    func authenticatePatente(patente:String,pin:String, completion: (Void -> Void)) {
        
        service.authenticate(licensePlate: patente, password: pin) { [unowned self]  (result) -> Void in
            do {
                if try result() {
                    self.licensePlate.currentLicensePlate = patente
                    completion()
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

    func showError(error: String) {
        self.errorLabel.text = error
        self.errorLabel.hidden = false
        self.aceptarbutton.enabled = true
        self.patenteTextField.enabled = true
        self.pinTextField.enabled = true
        self.cargandoSpinner.stopAnimating()
    }
    
}