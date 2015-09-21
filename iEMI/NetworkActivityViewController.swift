//
//  NetworkActivityViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 9/17/15.
//  Copyright © 2015 Rowies. All rights reserved.
//

import UIKit

class NetworkActivityViewController: UIViewController {
    
    // MARK: - Private properties
    private lazy var loadingView : LoadingView = {
        return LoadingView(frame: UIScreen.mainScreen().bounds)
    }()
    

    //MARK: - Public properties
    
    
    //MARK: - Getters / Setters

    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Loading view 
    
    private let kShowAnimationDuration = 0.2
    
    private func prepareForShowNetworkActivityView() {
        
        loadingView.removeFromSuperview()
        loadingView.alpha = 1.0
    }
    
    private func showNetworkActivityView(animated: Bool) {
        
        if !animated {
            
            self.view.addSubview(self.loadingView)
            
        } else {
            
            loadingView.alpha = 0.0
            self.view.addSubview(self.loadingView)

            UIView.animateWithDuration(kShowAnimationDuration, animations: {[unowned self] () -> Void in
                
                self.loadingView.alpha = 1.0
            })
        }
    }
    
    func showLoadingView(message: String, animated: Bool) {
        
        self.prepareForShowNetworkActivityView()
        
        self.loadingView.feedbackLabel!.text = message
        self.loadingView.feedbackLabel.textColor = UIColor.grayLabelDefaultColor()

        self.loadingView.loadingSpinner.hidden = false
        self.loadingView.loadingSpinner.startAnimating()

        self.showNetworkActivityView(animated)
    }
    
    func showErrorView(errorMessage: String?, animated: Bool) {
        
        self.prepareForShowNetworkActivityView()
        
        self.loadingView.feedbackLabel!.text = errorMessage
        self.loadingView.feedbackLabel.textColor = UIColor.redErrorColor()
        
        self.loadingView.loadingSpinner.hidden = true
        self.loadingView.loadingSpinner.stopAnimating()
        
        self.showNetworkActivityView(animated)
    }
    
    private let kHideAnimationDuration = 0.2
    
    func hideLoadingView(animated: Bool) {
        
        if !animated {
            
            loadingView.removeFromSuperview()
            
        } else {
            
            UIView.animateWithDuration(kHideAnimationDuration, animations: {[unowned self] () -> Void in
                
                self.loadingView.alpha = 0.0
                
            }, completion: { [unowned self] (success) -> Void in
                
                self.loadingView.removeFromSuperview()
                self.loadingView.alpha = 1.0
                
            })
        }
    }
    
}
