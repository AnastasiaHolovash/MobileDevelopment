//
//  PhotoCell.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 19.02.2021.
//

import UIKit

class MosaicCell: UICollectionViewCell {
    
    static let identifier = "kMosaicCollectionViewCell"

    var imageView = UIImageView()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        autoresizesSubviews = true
        
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.tintColor = .placeholderText
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = .placeholderImages
    }
    
}
