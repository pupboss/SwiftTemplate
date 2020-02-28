//
//  LaunchViewController.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 30/5/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if APIService.default.apiAuthToken != nil {
            
            APIService.default.fetchUserInfo(success: { (userInfo) in
                
                // Do some work
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController = NavigationController(rootViewController: ScanViewController())
                
            }) { (error) in
                APIService.default.clearAuthAndReLogin()
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = NavigationController(rootViewController: ScanViewController())
        }
    }
}
