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
    @IBOutlet weak var minusSignLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var moneySignLabel: UILabel!
    
    var debit: Debit {
        
        get{
            return self.debit
        }
        
        set(debit){
            
            self.consumoDireccionLabel.text = debit.address
            self.horaDesdeLabel.text = debit.timeStart
            
            self.consumoLabel.hidden = true
            self.minusSignLabel.hidden = true
            self.moneySignLabel.hidden = true
            self.spinner.startAnimating()
            
            if debit.timeEnd == nil { //still parked
                self.horaHastaLabel.text = kNowString
                self.spinner.stopAnimating()
                
            } else {
                
                self.horaHastaLabel.text = debit.timeEnd
                
                if let amount = debit.amount {
                    self.consumoLabel.hidden = false
                    self.minusSignLabel.hidden = false
                    self.moneySignLabel.hidden = false
                    self.spinner.stopAnimating()
                    self.consumoLabel.text = amount
                }
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
