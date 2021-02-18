//
//  UIApplicationExtension.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 17.02.2021.
//

import UIKit

extension UIApplication {
    
    public static func topViewController(_ base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = base as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        
        if let tabbarController = base as? UITabBarController {
            
            if let selected = tabbarController.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
    
    public var currentWindow: UIWindow? {
        
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
