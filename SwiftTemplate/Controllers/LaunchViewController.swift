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
        
        if APIService.shared.apiAuthToken != nil {
            
            SwiftProgressHUD.showWait()
            APIService.shared.fetchUserInfo(success: { (userInfo) in
                SwiftProgressHUD.hideAllHUD()
                
                // Do some work
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController = NavigationController(rootViewController: ScanViewController())
                
            }) { (error) in
                SwiftProgressHUD.hideAllHUD()
                APIService.shared.clearAuthAndReLogin()
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = NavigationController(rootViewController: RegisterViewController())
        }
    }
}
