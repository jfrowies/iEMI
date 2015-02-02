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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        self.authenticateUser()
    }
    
    func authenticateUser() {
        
    }
    
}
