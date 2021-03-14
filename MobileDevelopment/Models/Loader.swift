//
//  Loader.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 14.03.2021.
//

import UIKit
import SVProgressHUD

struct Loader {
    
    static func show() {
        
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func show(with progress: Float) {
        DispatchQueue.main.async {
            SVProgressHUD.showProgress(progress)
        }
    }
}
