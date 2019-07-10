//
//  SideMenuTableViewController.swift
//  Feels Like
//
//  Created by Babak Shirvani on 2019-03-13.
//  Copyright © 2019 Babak Shirvani. All rights reserved.
//

import UIKit


class SideMenuTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "autocompleteBackgroun"))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        switch indexPath.row {
            
        case 0: NotificationCenter.default.post(name: Notification.Name("loadData"), object: nil)
        case 1: NotificationCenter.default.post(name: NSNotification.Name("ShowAddNewCity"), object: nil)
        case 2: NotificationCenter.default.post(name: NSNotification.Name("ShowPolicy"), object: nil)
        case 3: NotificationCenter.default.post(name: NSNotification.Name("ShowTermsOfUse"), object: nil)
        case 4: NotificationCenter.default.post(name: NSNotification.Name("ShowAbout"), object: nil)
            
        default:
            break
        }
    }
}
