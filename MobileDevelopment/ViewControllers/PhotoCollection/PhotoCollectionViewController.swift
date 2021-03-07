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
    private var plusImage = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.thin))!
    private var loader = UIActivityIndicatorView(style: .large)
    private var selectedIndexPath: IndexPath!
    
    enum Section {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMosaicCollectionView()
        loaderSetup()
        configureDataSource()
        
        // Request authorisation to access the Photo Library.
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            if status != .authorized {
                self.displayPhotoAccessDeniedAlert()
            }
        }
    }
    
    private func setupMosaicCollectionView() {
        
        let mosaicLayout = MosaicLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: mosaicLayout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white
        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifier)
        
        view.addSubview(collectionView)
    }
    
    private func loaderSetup() {
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
    
    private func displayPhotoAccessDeniedAlert() {
        let message = "Access to photos has been previously denied by the user. Please enable photo access for this app in Settings -> Privacy."
        let alertController = UIAlertController(title: "Photo Access", message: message, preferredStyle: .alert)
        let openSettingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                
                // Take the user to the Settings app to change permissions.
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openSettingsAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func newSnapshot() -> NSDiffableDataSourceSnapshot<Section, UIImage> {
        
        var newSnapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        newSnapshot.appendSections([.main])
        var itemsArray = photos
        itemsArray.append(plusImage)
        
//        let additionalN = 5 - (photos.count + 1) % 5
//        itemsArray.append(contentsOf: Array(repeating: UIImage(), count: additionalN))
        
        newSnapshot.appendItems(itemsArray)
        return newSnapshot
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionViewController {
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let additionalN = 5 - (photos.count + 1) % 5
//        return photos.count + 1 + additionalN
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MosaicCell.identifier, for: indexPath) as? MosaicCell else {
//            preconditionFailure("Failed to load collection view cell")
//        }
//        if indexPath.item < photos.count {
//            let image = photos[indexPath.item]
//            image.accessibilityFrame = cell.frame
//            cell.imageView.image = image
//
//        } else if indexPath.item == photos.count {
//            cell.imageView.image = plusImage
//            cell.imageView.tintColor = .placeholderText
//
//        } else {
//            cell.imageView.image = UIImage()
//        }
//        return cell
//    }
    
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
            let photoVC = PhotoViewController.create(image: photos[indexPath.item])
            navigationController?.pushViewController(photoVC, animated: true)
        }
    }
}

// MARK: - ZoomingViewController

extension PhotoCollectionViewController: ZoomingViewController {
    
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        
        if let indexPath = selectedIndexPath {
            let cell = collectionView?.cellForItem(at: indexPath) as! MosaicCell
            return cell.imageView
        }
        return nil
    }
}
