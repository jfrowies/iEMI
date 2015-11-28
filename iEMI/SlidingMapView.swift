//
//  SlidingMapView.swift
//  iEMI
//
//  Created by Fer Rowies on 9/30/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit
import MapKit

let kDefaultDegreeSpamForCoordinateRegion = 0.005

@IBDesignable class SlidingMapView: UIView, MKMapViewDelegate {
    
    //Mark: - Private properties
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var footerLabel: UILabel!
    @IBOutlet private weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var visualEffectViewBottomConstraint: NSLayoutConstraint!
    
    private var view: UIView!
    private var mapAnnotations: [MKAnnotation] = []

    private let kMapViewHideConstant: CGFloat = 200
    private let kMapViewShowConstant: CGFloat = 0
    private let kMapViewHideShowAnimationDuration = 0.3

    private let kFooterViewHideConstant: CGFloat = -40
    private let kFooterViewShowConstant: CGFloat = 0
    private let kFooterHideShowAnimationDuration = 0.2

    //Mark: - Public properties
    
    var parkingLocation: ParkingLocation {
        
        get {
            return self.parkingLocation
        }
        
        set(location) {
            
            if let address = location.streetNameAndNumber {
                
                footerLabel.text = address
                self.showFooterView(animated: true)
                self.centerMapOnLocation(location)

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
        
        hideFooterView(animated: false)
        hideMapView(animated: false)
        
        mapView.delegate = self
        mapView.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 40.0, right: 0.0)

        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    private let kNibName: String = "SlidingMapView"
    
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
    
    func showMapView(animated animated: Bool) {
        
        if animated {
            UIView.animateWithDuration(kMapViewHideShowAnimationDuration, animations: { [unowned self] () -> Void in
                self.mapViewTopConstraint.constant = self.kMapViewShowConstant
                self.layoutIfNeeded()
                })
        } else {
            self.mapViewTopConstraint.constant = self.kMapViewShowConstant
            self.layoutIfNeeded()
        }
    }
    
    func hideMapView(animated animated: Bool) {
        
        if animated {
            UIView.animateWithDuration(kMapViewHideShowAnimationDuration, animations: { [unowned self] () -> Void in
                self.mapViewTopConstraint.constant = self.kMapViewHideConstant
                self.layoutIfNeeded()
                })
        } else {
            self.mapViewTopConstraint.constant = self.kMapViewHideConstant
            self.layoutIfNeeded()
        }
    }
    
    func centerMapOnLocation(location: ParkingLocation) {
        
        guard let addressString = formatedAddressForParking(location) else {
            return
        }
        
        let cleanStringData: NSData? = addressString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        guard cleanStringData != nil else { return }
        
        let cleanAddress: String? = String(data: cleanStringData!, encoding: NSASCIIStringEncoding)
        guard cleanAddress != nil else { return }
        
        CLGeocoder().geocodeAddressString(cleanAddress!) { [weak self] (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            guard error == nil else {
                return
            }
            
            if let placeMark = placemarks?.first {

                guard placeMark.locality == "Resistencia" else {
                    return
                }
                
                guard placeMark.country == "Argentina" else {
                    return
                }
                
                if let center = placeMark.location?.coordinate {
                    let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(kDefaultDegreeSpamForCoordinateRegion, kDefaultDegreeSpamForCoordinateRegion))
                    
                    let annotationPlaceMark = MKPlacemark.init(placemark: placeMark)
                    self?.mapAnnotations = [annotationPlaceMark]
                    self?.mapView.setRegion(region, animated: false)
                    self?.showMapView(animated: true)
                }
            }
        }
    }
    
    //Mark: - Private functions
    
    private func formatedAddressForParking(location: ParkingLocation) -> String? {
        
        
        guard let streetNameAndNumber = location.streetNameAndNumber else {
            return nil
        }
        
        var words = streetNameAndNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        guard words.count > 2 else {
            return nil
        }
        
        words = words.filter({ !$0.isEmpty })

        var addressString = ""
        
        //saving the number
        let addressNumber = words.popLast()!
        
        //putting the last word first (last name of street names on Resistencia goes first)
        let addressLastName = words.popLast()!
        addressString += addressLastName
        
        //adding the other words
        if words.count > 0 {
            addressString += " " + words.joinWithSeparator(" ")
        }
        //adding the number
        addressString += " " + addressNumber
        //adding the citi, province and country
        addressString += " Resistencia, Chaco, Argentina"
        
        return addressString
    }
    
    //Mark: - MKMapViewDelegate implementation
    
    private let slidingMapViewPinAnnotationId = "slidingMapViewPinAnnotation"
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: slidingMapViewPinAnnotationId)
        
        if #available(iOS 9.0, *) {
            pinAnnotationView.pinTintColor = UIColor.orangeGlobalTintColor()
        }
        
        pinAnnotationView.animatesDrop = true
        
        return pinAnnotationView
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        
        if fullyRendered {
            mapView.addAnnotations(self.mapAnnotations)
        }
    }

    
}