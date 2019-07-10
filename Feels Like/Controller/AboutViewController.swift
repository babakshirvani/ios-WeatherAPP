//
//  AboutViewController.swift
//  Feels Like
//
//  Created by Babak Shirvani on 2019-03-21.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAboutPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}
