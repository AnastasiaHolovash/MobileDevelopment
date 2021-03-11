//
//  PhotoCollectionViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 19.02.2021.
//

import UIKit
import Photos

class PhotoCollectionViewController: UICollectionViewController {
    
    // MARK: - Private properties
    
    private let imagePicker = ImagePicker(type: .image)
    private var photos: [UIImage] = []
    private var loader = UIActivityIndicatorView(style: .large)
    private var selectedIndexPath: IndexPath!
    private var layoutType: LayoutType = .compositional
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    private var mosaicLayout: UICollectionViewLayout!
    
    // MARK: - Nested Types
    
    enum Section {
        case main
    }
    
    enum LayoutType: String {
        case flow
        case compositional
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...37 {
            photos.append(UIImage(named: "\(i)")!)
        }
        
        setupMosaicLayout()
        setupMosaicCollectionView()
        loaderSetup()
        configureDataSource()
        
        // Request authorisation to access the Photo Library.
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            if status != .authorized {
                self.imagePicker.displayPhotoAccessDeniedAlert(in: self)
            }
        }
    }
    
    private func setupMosaicLayout() {
        
        let mosaicLayout = layoutType == .compositional ? MosaicCompositionalLayout.createLayout() : MosaicFlowLayout()
        collectionView.setCollectionViewLayout(mosaicLayout, animated: true)
    }
    
    private func setupMosaicCollectionView() {
        
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func loaderSetup() {
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        
        if motion == .motionShake {
            
            layoutType = layoutType == .compositional ? .flow : .compositional
            setupMosaicLayout()
            
            let alertController = UIAlertController(title: "Layout changed to \(layoutType.rawValue)", message: "", preferredStyle: .alert)
            self.present(alertController, animated: true) {
                UIView.animate(withDuration: 1.5) {
                    alertController.view.alpha = 0
                } completion: { _ in
                    alertController.dismiss(animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = selectedIndexPath {
            collectionView.scrollToItem(at: selectedIndexPath, at: .centeredVertically, animated: false)
        }
        view.layoutIfNeeded()
    }
    
    
    // MARK: - Private Functions
    
    private func selectImage() {
        
        view.isUserInteractionEnabled = false
        loader.startAnimating()
        
        imagePicker.setType(type: .image, from: .all).show(in: self) { [weak self] result in
            switch result {
            case let .success(image: image):
                self?.photos.append(image)
                if let snapshot = self?.newSnapshot() {
                    self?.dataSource.apply(snapshot, animatingDifferences: true)
                }
                self?.view.isUserInteractionEnabled = true
                self?.loader.stopAnimating()
            default:
                self?.view.isUserInteractionEnabled = true
                self?.loader.stopAnimating()
            }
        }
    }
    
    private func newSnapshot() -> NSDiffableDataSourceSnapshot<Section, UIImage> {
        
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        newSnapshot.appendSections([.main])
        var itemsArray = photos
        itemsArray.append(.plusCircle)
        
        newSnapshot.appendItems(itemsArray)
        return newSnapshot
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionViewController {
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MosaicCell, UIImage> { (cell, indexPath, item) in
            
            // Populate the cell with our item description.
            cell.imageView.image = item
        }
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: collectionView) { collectionView, indexPath, identifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        let snapshot = newSnapshot()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == photos.count {
            selectImage()
            
        } else if indexPath.item < photos.count {
            selectedIndexPath = indexPath
            
            let photoVC = PhotoPageViewController(images: photos, initialIndex: indexPath.item)
            photoVC.goBackToImageDelegate = self
            navigationController?.pushViewController(photoVC, animated: true)
        }
    }
}

// MARK: - ZoomingViewController

extension PhotoCollectionViewController: ZoomingViewDelegate {
    
    func zoomingImageView(for transition: ZoomTransitioningManager) -> UIImageView? {
        
        if let indexPath = selectedIndexPath {
            
            let cell = collectionView?.cellForItem(at: indexPath) as! MosaicCell
            return cell.imageView
        }
        print("ERROR")
        return nil
    }
}

// MARK: - PhotoViewControllerDelegate

extension PhotoCollectionViewController: PhotoViewControllerDelegate {
    
    func sourceImage(index: Int) {
        selectedIndexPath = IndexPath(item: index, section: 0)
        
        
//        let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 0))?.frame
//        self.collectionView.scrollRectToVisible(rect!, animated: true)
        
        
        //        collectionView.isPagingEnabled = false
//        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredVertically, animated: false)
        //        collectionView.isPagingEnabled = true
        //        self.collectionView.setNeedsLayout()
        
//        collectionView.isPagingEnabled = false
//        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredVertically, animated: false)
//
//
//        let temp = collectionView.contentOffset.y + view.safeAreaInsets.top - view.frame.height / 2
//
//        if collectionView.contentOffset.y + view.safeAreaInsets.top < view.frame.height / 2 {
//            print("Top !!!!!!!!!!!")
//            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
//        } else if temp.truncatingRemainder(dividingBy: view.frame.height) < view.frame.height / 2 {
//            print("Bottom !!!!!!!!!!!")
//            collectionView.scrollToItem(at: IndexPath(item: photos.count - 1, section: 0), at: .bottom, animated: false)
//        }
//
//        collectionView.isPagingEnabled = true
//        collectionView.setNeedsLayout()
    }
}
