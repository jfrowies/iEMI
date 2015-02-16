//
//  CreditoTableViewCell.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class CreditoTableViewCell: UITableViewCell {

    @IBOutlet weak var creditoLabel: UILabel!
    @IBOutlet weak var fechaCreditoLabel: UILabel!
    @IBOutlet weak var horaCreditoLabel: UILabel!
//    @IBOutlet weak var saldoLabel: UILabel!
    
    var credito: Credito {
        get{
            return self.credito
        }
        set(newCredito){
            self.creditoLabel.text = newCredito.importe
            self.fechaCreditoLabel.text = newCredito.fecha
            self.horaCreditoLabel.text = newCredito.hora
//            self.saldoLabel.text = newCredito.saldo
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
