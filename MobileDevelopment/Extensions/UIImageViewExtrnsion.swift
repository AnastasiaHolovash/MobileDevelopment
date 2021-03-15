//
//  UIImageViewExtrnsion.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 12.03.2021.
//

import UIKit

extension UIImageView {
    
    func setImage(from url: String) {
        
        image = UIImage.placeholderImages
        
        if let imageFromCache = App.imageCache.object(forKey: NSString(string: url)) {
            image = imageFromCache

        } else {
            let moviesDataManager = MoviesDataManager.shared
            moviesDataManager.loadImage(url: url) { [weak self] newImage in
                guard let newImage = newImage else {
                    return
                }
                App.imageCache.setObject(newImage, forKey: NSString(string: url))
                self?.image = newImage
            }
        }
    }
}
