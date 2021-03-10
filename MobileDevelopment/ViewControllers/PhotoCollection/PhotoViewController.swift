//
//  PhotoViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 26.02.2021.
//

import UIKit

protocol PhotoViewControllerDelegate: class {
    
    func sourceImage(index: Int)
}

class PhotoViewController: UIViewController {
    
    // MARK: - Statics
    
    static let id = "PhotoViewController"
    
    static func create(image: UIImage) -> PhotoViewController {

        let vc = UIStoryboard.main.instantiateViewController(identifier: id) as! PhotoViewController
        vc.image = image

        return vc
    }
    
//    static func create(images: [UIImage], initialIndex: Int) -> PhotoViewController {
//        
//        let vc = UIStoryboard.main.instantiateViewController(identifier: id) as! PhotoViewController
//        vc.image = images[initialIndex]
//        vc.newView = images[initialIndex + 1]
//        vc.newIndex = initialIndex + 1
//        
//        return vc
//    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public Variables
    
    public var image: UIImage!
    
//    var newView: UIImage!
//    var newIndex: Int!
    weak var delegate: PhotoViewControllerDelegate?
        
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        imageView.image = newView
//        delegate?.sourceImage(index: newIndex)
//    }
}

// MARK: - ZoomingViewController

extension PhotoViewController: ZoomingViewDelegate {
    
    func zoomingImageView(for transition: ZoomTransitioningManager) -> UIImageView? {
        
        return imageView
    }
}
