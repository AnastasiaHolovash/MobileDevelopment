//
//  File.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 15.03.2021.
//

import UIKit

class IndicatorCell: UICollectionViewCell {
    
    var inidicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        contentView.addSubview(inidicator)
        inidicator.frame = center(centerX: contentView.centerXAnchor,
                          centerY: contentView.centerYAnchor)
        inidicator.startAnimating()
    }
    
}
