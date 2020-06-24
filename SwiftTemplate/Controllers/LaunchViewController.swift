//
//  LaunchViewController.swift
//  SwiftTemplate
//
//  Created by Jie Li on 30/5/18.
//  Copyright © 2018 Meltdown Research. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if APIService.default.apiAuthToken != nil {
            
            APIService.default.fetchUserInfo(success: { (userInfo) in

                // Do some work

            }) { (error) in
                APIService.default.clearAuthAndReLogin()
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let nav = appDelegate.window!.rootViewController as! NavigationController
            nav.setViewControllers([ScanViewController()], animated: false)
        }
    }
}
