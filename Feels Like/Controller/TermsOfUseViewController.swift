//
//  TermsOfUseViewController.swift
//  Feels Like
//
//  Created by Babak Shirvani on 2019-03-21.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit
import WebKit

class TermsOfUseViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webViewTerms: UIView!
    
    

    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        
        
        webView = WKWebView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: webViewTerms.frame  , configuration: webConfiguration)
        webView.uiDelegate = self
        webViewTerms.addSubview(webView)
        constrainView(view: webView, toView: webViewTerms)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let myURL = URL(string:"https://babakshirvani.github.io/terms")
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
    

    @IBAction func backTermsPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
    

}
