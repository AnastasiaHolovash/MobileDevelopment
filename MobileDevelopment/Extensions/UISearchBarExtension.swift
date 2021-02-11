//
//  UISearchBarExtension.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 11.02.2021.
//

import UIKit

extension UISearchBar {
    
    // Due to searchTextField property who available iOS 13 only, extend this property for iOS 12
    public var compatibleSearchTextField: UITextField {
        
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                // iOS 13 previous devices
                return textField
            } else {
                // exception condition or error handler in here
                return UITextField()
            }
        }
    }
    
    public var activityIndicator: UIActivityIndicatorView? {
        return compatibleSearchTextField.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator: UIActivityIndicatorView
                    if #available(iOS 13.0, *) {
                        newActivityIndicator = UIActivityIndicatorView(style: .medium)
                    } else {
                        // Fallback on earlier versions
                        newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    }
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = UIColor.clear
                    compatibleSearchTextField.leftView = newActivityIndicator
                    let leftViewSize = compatibleSearchTextField.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                let imageView = UIImageView()
                if #available(iOS 13.0, *) {
                    imageView.image = UIImage(systemName: "magnifyingglass")
                } else {
                    // Fallback on earlier versions
                    imageView.image = UIImage(contentsOfFile: "magnifyingglass")
                }
                imageView.tintColor = .systemGray
                compatibleSearchTextField.leftView = imageView
            }
        }
    }
}
