//
//  PhotoViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 26.02.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    // MARK: - Statics
    
    static let id = "PhotoViewController"
    
    static func create(with image: UIImage) -> PhotoViewController {
        
        let vc = UIStoryboard.main.instantiateViewController(identifier: id) as! PhotoViewController
        vc.image = image
        
        return vc
    }
    
    static func create(with url: String) -> PhotoViewController {
        
        let vc = UIStoryboard.main.instantiateViewController(identifier: id) as! PhotoViewController
        vc.url = url
        
        return vc
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public Variables
    
    public var image: UIImage?
    public var url: String?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        if let image = image {
            imageView.image = image
        } else {
            imageView.setImage(from: url ?? "")
        }
    }
}
