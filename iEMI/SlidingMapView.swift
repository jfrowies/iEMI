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
    
    //Mark: - Private properties
    
    private var view: UIView!
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var footerLabel: UILabel!
    @IBOutlet private weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var visualEffectViewBottomConstraint: NSLayoutConstraint!
    
    private let kFooterViewHideConstant: CGFloat = -40
    private let kFooterViewShowConstant: CGFloat = 0

    private let kFooterHideShowAnimationDuration = 0.2

    //Mark: - Public properties
    
    var footerText: String? {
        
        get {
            return footerLabel.text
        }
        
        set(text) {
            if (text != nil) {
                footerLabel.text = text
                UIView.animateWithDuration(kFooterHideShowAnimationDuration, animations: { [unowned self] () -> Void in
                    self.visualEffectViewBottomConstraint.constant = self.kFooterViewShowConstant
                    self.layoutIfNeeded()
                })
            } else {
                UIView.animateWithDuration(kFooterHideShowAnimationDuration, animations: { [unowned self] () -> Void in
                    self.visualEffectViewBottomConstraint.constant = self.kFooterViewHideConstant
                    self.layoutIfNeeded()
                })
            }
        }
    }    
    
    //Mark: - View lifecycle
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        visualEffectViewBottomConstraint.constant = kFooterViewHideConstant

        self.layoutIfNeeded()
        
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