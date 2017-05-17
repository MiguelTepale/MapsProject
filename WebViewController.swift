//
//  WebViewController.swift
//  MapsProject
//
//  Created by Miguel Tepale on 5/15/17.
//  Copyright © 2017 Miguel Tepale. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var userUrl: String!
    var currentWebView: WKWebView!
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: userUrl) else {
            print("url value is nil")
            return
        }
        let request = URLRequest(url: url)
        
        currentWebView = WKWebView(frame: self.view.frame)
        currentWebView.navigationDelegate = self
        currentWebView.load(request)
        self.view.addSubview(currentWebView)
    }
}
