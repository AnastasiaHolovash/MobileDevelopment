//
//  MovieTableViewCell.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 09.02.2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let id = "MovieTableViewCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
        nameLabel.text = ""
        yearLabel.text = ""
        typeLabel.text = ""
        yearLabel.isHidden = false
        typeLabel.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
