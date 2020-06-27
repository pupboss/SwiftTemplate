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
        
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if APIService.default.apiAuthToken != nil {
            
            APIService.default.fetchUserInfo(success: { (userInfo) in
               // Do something
            }) { (error) in
                APIService.default.clearAuthAndReLogin()
            }
        } else {
//            APIService.default.clearAuthAndReLogin()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = UINavigationController(rootViewController: ScanViewController())
        }
    }
    
    func setupAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.tc.tint
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "icon_nav_back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "icon_nav_back")
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tc.tint]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UINavigationBar.appearance().isTranslucent = true
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
    }
}
