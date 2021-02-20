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
    private var plusImage = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.light))!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMosaicCollectionView()

        // Request authorization to access the Photo Library.
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
        collectionView.dataSource = self
        collectionView.register(MosaicCell.self, forCellWithReuseIdentifier: MosaicCell.identifer)

        view.addSubview(collectionView)
    }
    
    // MARK: - Private Funcs
    
    private func selectImage() {
        
        view.isUserInteractionEnabled = false
        
        imagePicker.setType(type: .image, from: .all).show(in: self) { [weak self] result in
            switch result {
            case let .success(image: image):
                
                self?.photos.append(image)
                self?.collectionView.reloadData()
//                self?.view.isUserInteractionEnabled = true
//                Loader.hide()
                
            default:
                self?.view.isUserInteractionEnabled = true
//                Loader.hide()
            }
        }
    }
    
    private func displayPhotoAccessDeniedAlert() {
        let message = "Access to photos has been previously denied by the user. Please enable photo access for this app in Settings -> Privacy."
        let alertController = UIAlertController(title: "Photo Access",
                                                message: message,
                                                preferredStyle: .alert)
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
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        return 10
        return photos.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MosaicCell.identifer, for: indexPath) as? MosaicCell else {
            preconditionFailure("Failed to load collection view cell")
        }

        if indexPath.item < photos.count {
            cell.imageView.image = photos[indexPath.item]
        } else {
            cell.imageView.image = plusImage
            cell.imageView.tintColor = .placeholderText
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == photos.count {
            Swift.debugPrint("plusImage")
            selectImage()
        }
    }
}
