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
        setupToast()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        APIService.default.apiAuthToken = "To simulate exsiting users" // To simulate exsiting users
        
        if APIService.default.apiAuthToken != nil {
            view.makeToastActivity(.center)
            
            APIService.default.fetchUserInfo { (result) in
                self.view.hideToastActivity()
                switch result {
                case .success(_):
                    // Do something
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = UINavigationController(rootViewController: NewsViewController())
                    break
                case .failure(_):
                    APIService.default.clearAuthAndReLogin()
                }
            }
        } else {
//            APIService.default.clearAuthAndReLogin()
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window!.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
    }
    
    func setupAppearance() {
        UINavigationBar.appearance().tintColor = .gray
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "icon_nav_back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "icon_nav_back")
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.tc.shadeTheme]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UINavigationBar.appearance().isTranslucent = true
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        
        UITabBar.appearance().backgroundColor = UIColor.tc.subBackground
        UITabBar.appearance().tintColor = UIColor.tc.tintTheme
    }
    
    func setupToast() {
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = false
        let style = ToastStyle()
        ToastManager.shared.style = style
        ToastManager.shared.duration = 2.0
    }
}
