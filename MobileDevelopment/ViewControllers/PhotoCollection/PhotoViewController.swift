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
    
    static func create(image: UIImage) -> PhotoViewController {
        
        let vc = UIStoryboard.main.instantiateViewController(identifier: id) as! PhotoViewController
        vc.image = image
        
        return vc
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public Variables
    
    public var image: UIImage!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
        
}

// MARK: - ZoomingViewController

extension PhotoViewController: ZoomingViewController {
    
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        
        return imageView
    }
}
