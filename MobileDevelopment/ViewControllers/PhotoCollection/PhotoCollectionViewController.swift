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
    private var hits: Hits?
    private var selectedIndexPath: IndexPath!
    private var layoutType: LayoutType = .compositional
    private var dataSource: UICollectionViewDiffableDataSource<Section, Hit>!
    private var mosaicLayout: UICollectionViewLayout!
    private let dataManager = MoviesDataManager.shared
    
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
        
        setupMosaicLayout()
        setupMosaicCollectionView()
        configureDataSource()
        
        // Loading Images
        Loader.show()
        dataManager.fetchImages { [weak self] data in
            if let data = data {
                self?.hits = data
                if let snapshot = self?.newSnapshot() {
                    self?.dataSource.apply(snapshot, animatingDifferences: false)
                }
            }
            Loader.hide()
        }
        
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        
        if motion == .motionShake {
            
            layoutType = layoutType == .compositional ? .flow : .compositional
            setupMosaicLayout()
            view.layoutIfNeeded()
            
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
    
    private func newSnapshot() -> NSDiffableDataSourceSnapshot<Section, Hit> {
        
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, Hit>()
        newSnapshot.appendSections([.main])
        guard let itemsArray = hits?.hits else {
            return newSnapshot
        }
        
        newSnapshot.appendItems(itemsArray)
        return newSnapshot
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionViewController {
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MosaicCell, Hit> { (cell, indexPath, item) in
            
            // Populate the cell with our item description.
            cell.imageView.setImage(from: item.webformatURL)
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Hit>(collectionView: collectionView) { collectionView, indexPath, identifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        let snapshot = newSnapshot()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        
        let photoVC = PhotoPageViewController(images: hits?.hits ?? [], initialIndex: indexPath.item)
        photoVC.goBackToImageDelegate = self
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard indexPath.row >= collectionView.numberOfItems(inSection: 0) - 1,
              let next = hits?.nextPage else {
            return
        }
        
        Loader.show()
        dataManager.fetchImages(page: next) { [weak self] data in
            guard let data = data else {
                Loader.hide()
                return
            }
            self?.hits?.merge(with: data)
            Loader.hide()
            if let snapshot = self?.newSnapshot() {
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            
            footerView.backgroundColor = .green
            footerView.frame = CGRect(x: 0, y: 0, width: footerView.frame.height, height: 100)
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
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
        return nil
    }
}

// MARK: - PhotoViewControllerDelegate

extension PhotoCollectionViewController: PhotoViewControllerDelegate {
    
    func sourceImage(index: Int) {
        
        selectedIndexPath = IndexPath(item: index, section: 0)
    }
}
