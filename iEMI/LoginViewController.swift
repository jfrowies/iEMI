//
//  LoginViewController.swift
//  iEMI
//
//  Created by Fernando Rowies on 2/2/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class LoginViewController: TabBarIconFixerViewController, UITextFieldDelegate {
    
    @IBOutlet weak var licensePlateTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let service: LoginService = LoginEMIService()
    let licensePlate = LicensePlate()
    
    private let kShowTabBarViewControllerSegue: String = "showTabBarViewController"
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentLicensePlate = self.licensePlate.currentLicensePlate {
            self.licensePlateTextField.text = currentLicensePlate
            self.showLoadingUI(true)
             self.getSessionCookie(patente: self.licensePlateTextField.text!) { [unowned self] () -> Void in
                self.performSegueWithIdentifier(self.kShowTabBarViewControllerSegue, sender: self)
            }
        } else {
            self.showLoadingUI(false)
            self.licensePlateTextField.becomeFirstResponder()
        }
    }
    
    func showLoadingUI(loading:Bool) {
        if loading {
            self.loginButton.enabled = false
            self.licensePlateTextField.enabled = false
            self.passwordTextField.enabled = false
            self.loadingSpinner.hidden = false
            self.loadingSpinner.startAnimating()
            self.errorLabel.hidden = true
        } else {
            self.loginButton.enabled = true
            self.licensePlateTextField.enabled = true
            self.passwordTextField.enabled = true
            self.loadingSpinner.stopAnimating()
            self.errorLabel.hidden = true
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.licensePlateTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        if textField == self.passwordTextField {
                self.loginTouched()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    //MARK: - IBActions

    @IBAction func loginTouched() {
        
        self.showLoadingUI(true)
        
        self.getSessionCookie(patente: self.licensePlateTextField.text!) { [unowned self] () -> Void in
            self.authenticatePatente(self.licensePlateTextField.text!, pin: self.passwordTextField.text!) { [unowned self]  () -> Void in
                self.performSegueWithIdentifier(self.kShowTabBarViewControllerSegue, sender: self)
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
        self.loginButton.enabled = true
        self.licensePlateTextField.enabled = true
        self.passwordTextField.enabled = true
        self.loadingSpinner.stopAnimating()
    }
    
}