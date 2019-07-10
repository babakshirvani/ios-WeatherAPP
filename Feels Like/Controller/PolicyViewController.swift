//
//  PolicyViewController.swift
//  Feels Like
//
//  Created by Babak Shirvani on 2019-03-21.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var secView: UIView!
    
    
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        webView = WKWebView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: secView.bounds, configuration: webConfiguration)
        webView.uiDelegate = self
        secView.addSubview(webView)
        constrainView(view: webView, toView: secView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:"https://babakshirvani.github.io/policy")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    func constrainView(view:UIView, toView contentView:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @IBAction func backPolicyPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
   
}
