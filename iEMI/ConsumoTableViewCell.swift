//
//  ConsumoTableViewCell.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

class ConsumoTableViewCell: UITableViewCell {

    @IBOutlet weak var consumoLabel: UILabel!
    @IBOutlet weak var consumoDireccionLabel: UILabel!
    @IBOutlet weak var horaDesdeLabel: UILabel!
    @IBOutlet weak var horaHastaLabel: UILabel!
    @IBOutlet weak var saldoLabel: UILabel!
    
    var consumo: Debit {
        get{
            return self.consumo
        }
        set(cons){
            self.consumoLabel.text = cons.importe
            self.consumoDireccionLabel.text = cons.direccion
            self.horaDesdeLabel.text = cons.horaDesde
            self.horaHastaLabel.text = cons.horaHasta
            self.saldoLabel.text = cons.saldo
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
