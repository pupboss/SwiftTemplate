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
        
        APIService.shared.apiAuthToken = "To simulate exsiting users" // To simulate exsiting users
        
        if APIService.shared.apiAuthToken != nil {
            view.makeToastActivity(.center)
            
            APIService.shared.fetchUserInfo { (result) in
                self.view.hideToastActivity()
                switch result {
                case .success(let userInfo):
                    // Do something
                    PublicService.shared.userInfo = userInfo
                    UIApplication.shared.windows.first!.rootViewController = UINavigationController(rootViewController: NewsViewController())
                    break
                case .failure(_):
                    APIService.shared.clearAuthAndReLogin()
                }
            }
        } else {
//            APIService.shared.clearAuthAndReLogin()
//            UIApplication.shared.windows.first!.rootViewController =
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
