//
//  MoviesViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 09.02.2021.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var moviesData: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        
        fetchMovieData(from: "MoviesList")
        tableView.reloadData()
    }
    
    private func fetchMovieData(from file: String) {
        
        do {
            if let path = Bundle.main.path(forResource: file, ofType: "txt"),
               let jsonData = try String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode(Search.self, from: jsonData)
                moviesData = decodedData.search
            }
        } catch {
            print(error)
        }
    }
    
    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieTableViewCell.id, bundle: Bundle.main), forCellReuseIdentifier: MovieTableViewCell.id)
    }

}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.id, for: indexPath) as! MovieTableViewCell
        
        let movie = moviesData[indexPath.row]
        
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
        
        if movie.poster != "" {
            cell.posterImageView.image = UIImage(named: movie.poster)
        }
            
        return cell
    }
}
