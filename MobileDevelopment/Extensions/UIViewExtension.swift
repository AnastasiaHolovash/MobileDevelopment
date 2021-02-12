//
//  UIViewExtension.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 12.02.2021.
//

import UIKit

extension UIView {
        
    func fadeTransition(_ duration: CFTimeInterval, isFromLeftToRight: Bool) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = .fade
        
        layer.add(transition, forKey: nil)
    }
}
