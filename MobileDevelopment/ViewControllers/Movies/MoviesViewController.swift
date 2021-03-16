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
