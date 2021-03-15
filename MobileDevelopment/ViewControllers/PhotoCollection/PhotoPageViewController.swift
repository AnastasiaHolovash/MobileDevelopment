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
    //    private var images: [UIImage]!
    private var hits: [Hit]!
    private var currentIndex: Int!
    
    // MARK: - Life cycle
    
    init(images: [Hit], initialIndex: Int) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.hits = images
        self.currentIndex = initialIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        hits.forEach { item in
            let vc = PhotoViewController.create(with: item.webformatURL)
            controllers.append(vc)
        }
        
        setViewControllers([controllers[currentIndex]], direction: .forward, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        goBackToImageDelegate?.sourceImage(index: currentIndex)
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
        currentIndex = index
    }
}

// MARK: - ZoomingViewController

extension PhotoPageViewController: ZoomingViewDelegate {
    
    func zoomingImageView(for transition: ZoomTransitioningManager) -> UIImageView? {
        
        let imageView = (controllers[currentIndex] as? PhotoViewController)?.imageView
        return imageView
    }
}
