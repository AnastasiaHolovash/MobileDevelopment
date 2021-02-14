//
//  UITableviewExtension.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 14.02.2021.
//

import UIKit

extension UITableView {
    
    func addPlaceholder(image: UIImage) {
        
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFit
        
        backgroundView = image
    }
    
    func removePlaceholder() {
        
        backgroundView = nil
    }
}
