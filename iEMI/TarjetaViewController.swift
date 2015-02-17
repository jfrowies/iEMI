//
//  TarjetaViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 2/17/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

struct Tarjeta {
    var TarNro = "", TarAno = "", TarSerie = ""
}

class TarjetaViewController: UIViewController {
    
    @IBOutlet weak var numeroDeTarjetaLabel: UILabel!
    @IBOutlet weak var cerrarButton: UIButton!
    
    // MARK: - Properties
    
    var tarjeta = Tarjeta()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadTarjeta()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTarjeta() {
    
        self.numeroDeTarjetaLabel.text = self.tarjeta.TarNro
        
        //TODO: mostrar toda la info de la tarjeta
        
    }

    @IBAction func cerrarButtonTouched(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
