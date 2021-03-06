//
//  PhotosViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 05.03.2021.
//

import UIKit

class PhotosViewController: UIViewController {

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>! = nil
    var collectionView: UICollectionView! = nil
    
    private var photos: [UIImage] = []
    private var plusImage = UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.thin))!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
    }

}

extension PhotosViewController {

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let bigItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalWidth(0.5)))
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalWidth(0.25)))

            let trailingVerticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                  heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)

            let topHorizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.5)),
                
                subitems: [trailingVerticalGroup, bigItem, trailingVerticalGroup])
            
            let downHorizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.5)),
                
                subitems: [bigItem, trailingVerticalGroup, trailingVerticalGroup])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1.0)),
                
                subitems: [topHorizontalGroup, downHorizontalGroup])
            
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section

        }
        return layout
    }
}

extension PhotosViewController {
    
   func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MosaicCell, UIImage> { (cell, indexPath, item) in
            
            // Populate the cell with our item description.
            cell.imageView.image = item
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: collectionView) { collectionView, indexPath, identifier in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([Section.main])
        var itemsArray = photos
        itemsArray.append(plusImage)
        snapshot.appendItems(itemsArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
