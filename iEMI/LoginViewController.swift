//
//  LoginViewController.swift
//  iEMI
//
//  Created by Fernando Rowies on 2/2/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var licensePlateTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    let service: LoginService = LoginEMIService()
    let licensePlate = LicensePlate()
    let settings = Settings()
    
    private let kShowTabBarViewControllerSegue: String = "showTabBarViewController"
    
    //MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        self.showLoadingUI(false)
        self.licensePlateTextField.text = self.licensePlate.currentLicensePlate
        self.passwordTextField.text = ""

        if  (self.licensePlate.currentLicensePlate != nil) {

            if (settings.autoLogin) {
               self.getSessionCookie()
            } else {
                self.passwordTextField.becomeFirstResponder()
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
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
    
    //MARK: - Keyboard show/hide notifications
    
    func keyboardWillShow() {
        
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        self.scrollView.setContentOffset(CGPointMake(0, 50), animated: true)
    }
    
    func keyboardWillHide() {
        
        self.scrollView.contentInset = UIEdgeInsetsZero
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.errorLabel.hidden = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.licensePlateTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        if textField == self.passwordTextField {
            textField.resignFirstResponder()
            self.loginTouched()
        }
        
        return true;
    }
    
    //MARK: - Authentication
    
    private func authenticate() {
        
        self.showLoadingUI(true)
        
        self.getSessionCookie(patente: self.licensePlateTextField.text!) { [unowned self] () -> Void in
            self.authenticatePatente(self.licensePlateTextField.text!, pin: self.passwordTextField.text!) { [unowned self]  () -> Void in
                self.performSegueWithIdentifier(self.kShowTabBarViewControllerSegue, sender: self)
            }
        }
    }
    
    private func getSessionCookie() {
        
        self.showLoadingUI(true)
        
        self.getSessionCookie(patente: self.licensePlateTextField.text!) { [unowned self] () -> Void in
                self.performSegueWithIdentifier(self.kShowTabBarViewControllerSegue, sender: self)
        }
    }
    
    //MARK: - IBActions

    @IBAction func loginTouched() {
        self.authenticate()
    }
    
    //MARK: - Service calls
    
    private let defaultErrorDescription = NSLocalizedString("Unknown error.", comment: "default error message")
        
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