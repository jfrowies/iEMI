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
    @IBOutlet weak var minusSignLabel: UILabel!
    @IBOutlet weak var moneySignLabel: UILabel!
    
    var consumo: Debit {
        
        get{
            return self.consumo
        }
        
        set(cons){
            self.consumoDireccionLabel.text = cons.address
            self.horaDesdeLabel.text = cons.timeStart
            
            if cons.timeEnd == nil { //still parked
                self.saldoLabel.hidden = true
                self.consumoLabel.hidden = true
                self.minusSignLabel.hidden = true
                self.moneySignLabel.hidden = true
                
                self.horaHastaLabel.text = kNowString
                
            } else {
                self.saldoLabel.hidden = false
                self.consumoLabel.hidden = false
                self.minusSignLabel.hidden = false
                self.moneySignLabel.hidden = false

                self.saldoLabel.text = cons.balance
                self.consumoLabel.text = cons.amount
                self.horaHastaLabel.text = cons.timeEnd
            }
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
