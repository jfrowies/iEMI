//
//  Transaction.swift
//  iEMI
//
//  Created by Fer Rowies on 2/16/15.
//  Copyright (c) 2015 Rowies. All rights reserved.
//

import UIKit

protocol Transaction: NSObjectProtocol {
    
    var timestamp: String { get }
    var balance: String? { get set }
    
}
