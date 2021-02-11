//
//  MovieTableViewCell.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 09.02.2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Static variables
    
    static let id = "MovieTableViewCell"

    // MARK: - IBOutlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = UIImage(systemName: "list.and.film")
        nameLabel.text = ""
        yearLabel.text = ""
        typeLabel.text = ""
        yearLabel.isHidden = false
        typeLabel.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .default
    }
}
