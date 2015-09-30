//
//  SlidingMapView.swift
//  iEMI
//
//  Created by Fer Rowies on 9/30/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit
import MapKit

@IBDesignable class SlidingMapView: UIView {
    
    private var view: UIView!
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet weak var footerLabel: UILabel!

    @IBOutlet private weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var visualEffectViewBottomConstraint: NSLayoutConstraint!
    
    //Mark: - Getters/Setters
    
    
    //Mark: - View lifecycle
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    let kNibName: String = "SlidingMapView"
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: kNibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
}