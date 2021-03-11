//
//  PhotoPageViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 10.03.2021.
//

import UIKit

protocol PhotoViewControllerDelegate: class {
    
    func sourceImage(index: Int)
}

class PhotoPageViewController: UIPageViewController {
    
    static func create(images: [UIImage], initialIndex: Int) -> PhotoPageViewController {
        
        let vc = PhotoPageViewController()
        vc.images = images
        vc.curentIndex = initialIndex
        
        return vc
    }
    
    weak var goBackToImageDelegate: PhotoViewControllerDelegate?
    
    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    
    var images: [UIImage]!
    var curentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        
        addChild(pageController)
        view.addSubview(pageController.view)
        
        let views = ["pageController": pageController.view] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
        images.forEach { image in
            let vc = PhotoViewController.create(image: image)
            controllers.append(vc)
        }
        
        pageController.setViewControllers([controllers[curentIndex]], direction: .forward, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        goBackToImageDelegate?.sourceImage(index: curentIndex)
    }
    
}

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate

extension PhotoPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                curentIndex = index - 1
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                curentIndex = index + 1
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        return nil
    }
}

// MARK: - ZoomingViewController

extension PhotoPageViewController: ZoomingViewDelegate {
    
    func zoomingImageView(for transition: ZoomTransitioningManager) -> UIImageView? {
                
        let imageView = (controllers[curentIndex] as? PhotoViewController)?.imageView
        return imageView
    }
}
