//
//  DetailsViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 11.02.2021.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    // MARK: - Statics
    
    static let id = "DetailsViewController"
    
    static func create(movie: Movie) -> DetailsViewController {
        
        let vc = UIStoryboard.main.instantiateViewController(identifier: id) as! DetailsViewController
        vc.movie = movie
        
        return vc
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: DetailTableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Variables
    
    public var movie: Movie!
    
    private var tableViewData: [(String, String)] = []

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData = movie.notEmptyProperties
        nameLabel.text = movie.title
        
        if let image = MoviesDataManager.shared.fetchMovieImage(for: movie.poster) {
            imageView.image = image
        } else {
            imageView.isHidden = true
            tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: nameLabel.frame.height)
        }
        tableViewSetup()
    }
    
    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.detailTableViewDelegate = self
        tableView.register(UINib(nibName: DetailsTableViewCell.id, bundle: Bundle.main), forCellReuseIdentifier: DetailsTableViewCell.id)
    }

}

// MARK: - UITableViewDataSource

extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.notEmptyProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.id, for: indexPath) as! DetailsTableViewCell
        
        cell.nameLabel.text = tableViewData[indexPath.row].0
        cell.infoLabel.text = tableViewData[indexPath.row].1
        
        return cell
    }
}

// MARK: - DetailTableViewDelegate

extension DetailsViewController: DetailTableViewDelegate {
    
    func setTitle(_ needSetTitle: Bool) {
        
        title = needSetTitle ? movie.title : ""
    }
}
