//
//  MosaicCompositionalLayout.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 07.03.2021.
//

import UIKit

final class MosaicCompositionalLayout: UICollectionViewLayout {
    
    static func createLayout() -> UICollectionViewLayout {
        
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
