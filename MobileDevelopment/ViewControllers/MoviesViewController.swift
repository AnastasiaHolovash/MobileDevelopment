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
    
    // MARK: - Private variables and properties
    
    private var moviesData: [Movie] = []
    private var filteredMoviesData: [Movie] = []
    private let moviesDataManager = MoviesDataManager.shared
    private var searchController: UISearchController!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        searchControllerSetup()
        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        
        moviesData = moviesDataManager.fetchMoviesList() ?? []
        tableView.reloadData()
    }
    
    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MovieTableViewCell.id, bundle: Bundle.main), forCellReuseIdentifier: MovieTableViewCell.id)
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
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchController.isActive ? filteredMoviesData.count : moviesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.id, for: indexPath) as! MovieTableViewCell
        
        let movie = searchController.isActive ? filteredMoviesData[indexPath.row] : moviesData[indexPath.row]
        
        cell.nameLabel.text = movie.title
        
        if movie.year == "" {
            cell.yearLabel.isHidden = true
        } else {
            cell.yearLabel.text = movie.year
        }
        
        if movie.type == "" {
            cell.typeLabel.isHidden = true
        } else {
            cell.typeLabel.text = movie.type
        }
        
        if let image = moviesDataManager.fetchMovieImage(for: movie.poster) {
            cell.posterImageView.image = image
        }
            
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let id = searchController.isActive ? filteredMoviesData[indexPath.row].imdbID : moviesData[indexPath.row].imdbID
        
        guard let movie = moviesDataManager.fetchMovieData(for: id) else {
            return
        }
        
        let detailsVC = DetailsViewController.create(movie: movie)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension MoviesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.isLoading = true
        guard let enteredText = searchController.searchBar.text else {
            return
        }
        filteredMoviesData = moviesData.filter{ $0.title.contains(enteredText) }
        tableView.reloadData()
        searchController.searchBar.isLoading = false
    }
}

// MARK: - UISearchBarDelegate

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.isLoading = false
        tableView.reloadData()
    }
}
