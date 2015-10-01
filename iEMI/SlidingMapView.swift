//
//  SlidingMapView.swift
//  iEMI
//
//  Created by Fer Rowies on 9/30/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

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
    
    var address: String? {
        
        get {
            return footerLabel.text
        }
        
        set(text) {
            
            footerLabel.text = text
            
            if let textAddress = text {
                self.showFooterView(animated: true)
                self.centerMapOnAddress(textAddress)
            } else {
                self.hideFooterView(animated: true)
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
    
    
    //Mark: - Public functions

    func showFooterView(animated animated: Bool) {
        
        if animated {
            UIView.animateWithDuration(kFooterHideShowAnimationDuration, animations: { [unowned self] () -> Void in
                self.visualEffectViewBottomConstraint.constant = self.kFooterViewShowConstant
                self.layoutIfNeeded()
                })
        } else {
            self.visualEffectViewBottomConstraint.constant = self.kFooterViewShowConstant
            self.layoutIfNeeded()
        }
    }
    
    func hideFooterView(animated animated: Bool) {
        
        if animated {
            UIView.animateWithDuration(kFooterHideShowAnimationDuration, animations: { [unowned self] () -> Void in
                self.visualEffectViewBottomConstraint.constant = self.kFooterViewHideConstant
                self.layoutIfNeeded()
                })
        } else {
            self.visualEffectViewBottomConstraint.constant = self.kFooterViewHideConstant
            self.layoutIfNeeded()
        }
    }
    
    private let kDefaultDegreeSpamForCoordinateRegion = 0.005

    func centerMapOnAddress(addressString: String) {
        
        let cleanStringData: NSData? = addressString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        guard cleanStringData != nil else { return }
        
        let cleanAddress: String? = String(data: cleanStringData!, encoding: NSASCIIStringEncoding)
        guard cleanAddress != nil else { return }
        
        CLGeocoder().geocodeAddressString(cleanAddress!) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            guard error == nil else {
                return
            }
            
            if let placeMark = placemarks?.first {

                if let center = placeMark.location?.coordinate {
                    let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(self.kDefaultDegreeSpamForCoordinateRegion, self.kDefaultDegreeSpamForCoordinateRegion))
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
}