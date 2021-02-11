//
//  DetailTableView.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 12.02.2021.
//

import UIKit

class DetailTableView: UITableView {
    
    // MARK: -  Variables
    
    var imageViewHeight: NSLayoutConstraint?
    var imageViewBottom: NSLayoutConstraint?
    var isSetTitle: Bool = false
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Sets variables values
        guard let header = tableHeaderView else { return }
        if let catImageView = header.subviews.first as? UIImageView {
            imageViewHeight = catImageView.constraints.filter{ $0.identifier == "imageViewHeight" }.first
            imageViewBottom = constraints.filter{ $0.identifier == "imageViewBottom" }.first
        }
        
        let offsetY = -contentOffset.y
        
        // Parallax effect
        imageViewBottom?.constant = offsetY >= 0 ? 0 : offsetY / 2
        imageViewHeight?.constant = max(header.bounds.height, header.bounds.height + offsetY)
        header.clipsToBounds = offsetY <= 0
    
        // Tells to detailTableViewDelegate whether a title is required
//        if (offsetY > -263.0) && isSetTitle {
//            isSetTitle = false
//            detailTableViewDelegate?.setTitle(false)
//        } else if (offsetY < -263.0) && !isSetTitle {
//            isSetTitle = true
//            detailTableViewDelegate?.setTitle(true)
//        }
    }

}

