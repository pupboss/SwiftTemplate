//
//  NavigationController.swift
//  SwiftTemplate
//
//  Created by Jie Li on 30/5/18.
//  Copyright © 2018 Meltdown Research. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
