//
//  PhotoPageViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 10.03.2021.
//

import UIKit

// MARK: - PhotoViewControllerDelegate

protocol PhotoViewControllerDelegate: class {
    
    func sourceImage(index: Int)
}

class PhotoPageViewController: UIPageViewController {
    
    // MARK: - Delegate
    
    weak var goBackToImageDelegate: PhotoViewControllerDelegate?
    
    // MARK: - Private Variables
    
    private var controllers = [UIViewController]()
    private var images: [UIImage]!
    private var curentIndex: Int!
    
    // MARK: - Life cycle
    
    init(images: [UIImage], initialIndex: Int) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.images = images
        self.curentIndex = initialIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        images.forEach { image in
            let vc = PhotoViewController.create(image: image)
            controllers.append(vc)
        }
        
        setViewControllers([controllers[curentIndex]], direction: .forward, animated: false)
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
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?[0] else {
            return
        }
        guard let index = controllers.firstIndex(of: viewController) else {
            return
        }
        curentIndex = index
    }
}

// MARK: - ZoomingViewController

extension PhotoPageViewController: ZoomingViewDelegate {
    
    func zoomingImageView(for transition: ZoomTransitioningManager) -> UIImageView? {
        
        let imageView = (controllers[curentIndex] as? PhotoViewController)?.imageView
        return imageView
    }
}
