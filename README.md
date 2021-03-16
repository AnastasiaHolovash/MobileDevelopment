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
    Лабораторна робота №6
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

## Варіант № 1 та 5
(8206 mod 2) + 1 = 1
(8206 mod 6) + 1 = 5

## Результати роботи додатка

<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab6/GifLab6/1.gif" width="300">
<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab6/GifLab6/2.gif" width="300">

## Лістинг коду

#### DataManager.swift
```swift
//
//  DataManager.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 11.02.2021.
//

import UIKit
import Alamofire

final class DataManager {
    
    static let shared = DataManager()
    
    private init() { }
    
    static let apiKEY = "779d5b49"
    static let imagesApiKey = "19193969-87191e5db266905fe8936d565"
    
    var urlComponents: URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "www.omdbapi.com"
        urlComponents.queryItems = [URLQueryItem(name: "apikey", value: DataManager.apiKEY)]
        return urlComponents
    }
    
    var imagesUrlComponents: URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pixabay.com"
        urlComponents.path = "/api/"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: DataManager.imagesApiKey)]
        return urlComponents
    }
    
    private func fetch<Type: Decodable>(urlComponents: URLComponents, parameters: [String: String], completion: @escaping(Type?) -> Void) {
        
        AF.request(urlComponents, parameters: parameters)
            .validate()
            .responseDecodable(of: Type.self) { response in
                guard let data = response.value else {
                    completion(nil)
                    return
                }
                completion(data)
            }
    }
    
    public func fetchMoviesList(for searchText: String, page: Int = 1, completion: @escaping(Pagination<Movie>?) -> Void){
        
        let parameters = [
            "s" : "\(searchText)",
            "page" : "\(page)",
            "count" : "10",
        ]
        fetch(urlComponents: urlComponents, parameters: parameters, completion: completion)
    }
    
    public func fetchMovie(for id: String, completion: @escaping(Movie?) -> Void) {
        
        let parameters = [
            "i" : "\(id)",
        ]
        fetch(urlComponents: urlComponents, parameters: parameters, completion: completion)
    }
    
    public func fetchImages(page: Int = 1, completion: @escaping(Hits?) -> Void) {
        
        let parameters = [
            "q" : "​fun+party",
            "image_type": "photo",
            "per_page" : "30",
            "page" : "\(page)"
        ]
        fetch(urlComponents: imagesUrlComponents, parameters: parameters, completion: completion)
    }
    
    public func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard url != "N/A" , let url = URL(string: url) else {
            completion(nil)
            return
        }
        AF.request(url)
            .validate()
            .responseData { response in
                guard let data = response.value, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                completion(image)
            }
    }
    
    private func printJson(urlComponents: URLComponents, parameters: [String: String]) {
        
        AF.request(urlComponents, parameters: parameters)
            .validate()
            .responseData { response in
                if let data = response.value,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    print(String(decoding: jsonData, as: UTF8.self))
                } else {
                    print(response.error as Any)
                }
            }
    }
}

```

#### MoviesViewController.swift

```swift
//
//  MoviesViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 09.02.2021.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private variables and properties
    
    private var filteredMoviesData: Pagination<Movie>? {
        didSet {
            if filteredMoviesData?.items.isEmpty ?? true {
                tableView.addPlaceholder(image: .tableViewPlaceholder)
            } else {
                tableView.removePlaceholder()
            }
            tableView.reloadData()
        }
    }
    
    private var searchController: UISearchController!
    private var keyboardHandler: KeyboardEventsHandler!
    private var footerActivityIndicator: UIActivityIndicatorView!
    private let moviesDataManager = DataManager.shared
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        searchControllerSetup()
        
        keyboardHandler = KeyboardEventsHandler(forView: view, scroll: tableView)
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        tableView.addPlaceholder(image: .tableViewPlaceholder)
        tableView.reloadData()
    }
    
    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MovieTableViewCell.id, bundle: Bundle.main), forCellReuseIdentifier: MovieTableViewCell.id)
        
        // Activity Indicator
        footerActivityIndicator = UIActivityIndicatorView(style: .medium)
        footerActivityIndicator.hidesWhenStopped = true
        footerActivityIndicator.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableFooterView = footerActivityIndicator
    }
    
    private func searchControllerSetup() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.compatibleSearchTextField.returnKeyType = .done
        
        navigationItem.searchController = searchController
        
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddNewMovie" {
            let vc = segue.destination as! AddNewMovieViewController
            vc.delegate = self
        }
    }
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredMoviesData?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.id, for: indexPath) as! MovieTableViewCell
        
        guard let movie = filteredMoviesData?.items[indexPath.row] else {
            return cell
        }
        cell.config(movie)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let id = filteredMoviesData?.items[indexPath.row].imdbID else {
            return
        }
        Loader.show()
        moviesDataManager.fetchMovie(for: id) { [weak self] movie in
            guard let movie = movie else {
                Loader.hide()
                return
            }
            Loader.hide()
            let detailsVC = DetailsViewController.create(movie: movie)
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard indexPath.row >= tableView.numberOfRows(inSection: 0) - 1,
              let next = filteredMoviesData?.nextPage else {
            return
        }
        tableView.tableFooterView?.isHidden = false
        guard let enteredText = searchController.searchBar.text else {
            return
        }
        moviesDataManager.fetchMoviesList(for: enteredText, page: next) { [weak self] data in
            guard let data = data else {
                tableView.tableFooterView?.isHidden = true
                return
            }
            self?.filteredMoviesData?.merge(with: data)
            tableView.tableFooterView?.isHidden = true
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating

extension MoviesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let enteredText = searchController.searchBar.text, enteredText.count > 2 else {
            filteredMoviesData?.items = []
            return
        }
        searchController.searchBar.isLoading = true
        
        moviesDataManager.fetchMoviesList(for: enteredText, page: 1) { [weak self] data in
            guard let data = data else {
                searchController.searchBar.isLoading = false
                self?.filteredMoviesData?.items = []
                return
            }
            self?.filteredMoviesData = data
            searchController.searchBar.isLoading = false
        }
    }
}

// MARK: - UISearchBarDelegate

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchController.searchBar.isLoading = false
        tableView.tableFooterView?.isHidden = true
        filteredMoviesData?.items = []
        tableView.reloadData()
    }
}

// MARK: - AddNewMovieViewControllerDelegate

extension MoviesViewController: AddNewMovieViewControllerDelegate {
    
    func saveNewMovie(_ movie: Movie) {
        
        // Place to add new movie
    }
}

```

#### PhotoCollectionViewController.swift

```swift
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
    private let dataManager = DataManager.shared
    
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
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
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
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


## Висновок

Під час виконання лабораторної роботи було покращено навички зі створення мобільних додатків для операційної системи iOS. 
У даній роботі було додано роботу із сервером. Дані, які отримані із сервера відображаються в таблиці та колекції. Виконується кешування картинок, для уникнення повторної загрузки та пагінація, для прискорення отримання потрібних даних, та уникнення завантаження даних, що не будуть відображатися .
