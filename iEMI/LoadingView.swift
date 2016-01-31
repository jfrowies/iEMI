//
//  LoadingView.swift
//  iEMI
//
//  Created by Fer Rowies on 9/14/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

@IBDesignable class LoadingView: ResizableView {
    
    private var view: UIView!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var feedbackLabel: UILabel!
    
}
