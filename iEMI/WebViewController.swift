//
//  WebViewController.swift
//  iEMI
//
//  Created by Fer Rowies on 1/30/16.
//  Copyright © 2016 Rowies. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    internal var url: NSURL?
    
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var webView: UIWebView!

    // Mark: - View Controller lyfe cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.scalesPageToFit = true;
        if let url = self.url {
            self.webView.loadRequest(NSURLRequest(URL: url))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Mark: - Actions
    
    @IBAction func didTouchDone(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTouchRefresh(sender: AnyObject) {
        if let url = self.url {
            self.webView.loadRequest(NSURLRequest(URL: url))
        }
    }

}
