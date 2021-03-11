<p align="center">
    НАЦІОНАЛЬНИЙ ТЕХНІЧНИЙ УНІВЕРСИТЕТ УКРАЇНИ
</p>
<p align="center">
    “КИЇВСЬКИЙ ПОЛІТЕХНІЧНИЙ ІНСТИТУТ ІМЕНІ ІГОРЯ СІКОРСЬКОГО”
</p>
<p align="center">
    Факультет інформатики та обчислювальної техніки
</p>
<p align="center">
    Кафедра обчислювальної техніки
</p>
<br/>
<br/>
<br/>
<br/>
<p align="center">
    Лабораторна робота №5
</p>
<p align="center">
    з дисципліни “Програмування мобільних систем”
</p>
<br/>
<br/>
<br/>
<br/>
<br/>
<p align="right">
    Виконала:
</p>
<p align="right">
    студентка групи ІВ-82
</p>
<p align="right">
    ЗК ІВ-8206
</p>
<p align="right">
    Головаш Анастасія
</p>
<p align="center">
    Київ 2021
</p>

## Варіант № 1
(8206 mod 6) + 1 = 5

## Результати роботи додатка

<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab5/GifLab5/1.gif" width="300">
<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab5/GifLab5/2.gif" height="300">

## Лістинг коду

#### PhotoCollectionViewController.swift
```swift
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
        
        #if DEBUG
        for i in 1...30 {
            if let image = UIImage(named: "\(i)") {
                photos.append(image)
            }
        }
        #endif
        
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
        return nil
    }
}

// MARK: - PhotoViewControllerDelegate

extension PhotoCollectionViewController: PhotoViewControllerDelegate {
    
    func sourceImage(index: Int) {
        
        selectedIndexPath = IndexPath(item: index, section: 0)
    }
}

```

#### MosaicCompositionalLayout.swift

```swift
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

```

#### MosaicFlowLayout.swift

```swift
import UIKit

enum MosaicSegmentStyle {
    
    case bigItemCenter(Int)
    case bigItemLeft(Int)
}

final class MosaicFlowLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        //  - Combine contentBounds with attributes.frame.
        let count = collectionView.numberOfItems(inSection: 0)
        
        var currentIndex = 0
        var segment: MosaicSegmentStyle = .bigItemLeft(0)
        var lastFrame: CGRect = .zero
        
        let cvWidth = collectionView.bounds.size.width
        
        while currentIndex < count {
            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + 1.0, width: cvWidth, height: cvWidth / 2)
            
            var segmentRect = CGRect()
            
            switch segment {
            case let .bigItemCenter(n):
                segmentRect = bigItemCenterSegment(for: segmentFrame, itemN: n)
                
            case let .bigItemLeft(n):
                segmentRect = bigItemLeftSegment(for: segmentFrame, itemN: n)
            }
            
            // Create and cache layout attributes for calculated frames.
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
            attributes.frame = segmentRect
            
            cachedAttributes.append(attributes)
            contentBounds = contentBounds.union(segmentRect)
            
            currentIndex += 1
            
            // Determine the next segment style.
            switch segment {
            case let .bigItemCenter(n):
                segment = n < 4 ? .bigItemCenter(n + 1) : .bigItemLeft(0)
                if n == 4 {
                    lastFrame = segmentRect
                }
            case let .bigItemLeft(n):
                segment = n < 4 ? .bigItemLeft(n + 1) : .bigItemCenter(0)
                if n == 4 {
                    lastFrame = segmentRect
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        // Find any cell that sits within the query rect.
        guard let lastIndex = cachedAttributes.indices.last,
              let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
        
        // Starting from the match, loop up and down through the array until all the attributes
        // have been added within the query rect.
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        
        return attributesArray
    }
    
    // Perform a binary search on the cached attributes array.
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }
    
    private func bigItemCenterSegment(for frame: CGRect, itemN: Int) -> CGRect {
        
        let oneFourthHorizontalSlice = frame.dividedIntegral(fraction: 1.0 / 4.0, from: .minXEdge)
        let twoThirdHorizontalSlice = oneFourthHorizontalSlice.second.dividedIntegral(fraction: 2.0 / 3.0, from: .minXEdge)
        
        if itemN == 2 {
            return twoThirdHorizontalSlice.first
        }
        
        let oneSecondVerticalSlice1 = oneFourthHorizontalSlice.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
        
        if itemN <= 1 {
            return itemN == 0 ? oneSecondVerticalSlice1.first : oneSecondVerticalSlice1.second
        }
        
        let oneSecondVerticalSlice2 = twoThirdHorizontalSlice.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
        
        return itemN == 3 ? oneSecondVerticalSlice2.first : oneSecondVerticalSlice2.second
    }
    
    private func bigItemLeftSegment(for frame: CGRect, itemN: Int) -> CGRect {
        
        let halfHorizontalSlice = frame.dividedIntegral(fraction: 0.5, from: .minXEdge)
        
        if itemN == 0 {
            return halfHorizontalSlice.first
        }
        let oneThirdHorizontalSlice = halfHorizontalSlice.second.dividedIntegral(fraction: 0.5, from: .minXEdge)
        let oneSecondVerticalSlice1 = oneThirdHorizontalSlice.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
        
        if itemN <= 2 {
            return itemN == 1 ? oneSecondVerticalSlice1.first : oneSecondVerticalSlice1.second
        }
        
        let oneSecondVerticalSlice2 = oneThirdHorizontalSlice.second.dividedIntegral(fraction: 0.5, from: .minYEdge)
        return itemN == 3 ? oneSecondVerticalSlice2.first : oneSecondVerticalSlice2.second
    }
}

```


## Висновок

Під час виконання лабораторної роботи було покращено навички зі створення мобільних додатків для операційної системи iOS. 
У даній роботі було додано колекцію (UICollectionView),  яка відображає зображення, що додаються користувачам з системної галереї.  Налаштовано перегляд картинок. Layout колекції виконаний двома способами: FlowLayout та CompositionalLayout. Layout змінюється якщо потрясти смартфон.
