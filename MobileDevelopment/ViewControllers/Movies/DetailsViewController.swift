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
    
    // MARK: - Public Variables
    
    public var movie: Movie!
    
    // MARK: - Private Variables
    
    private var tableViewData: [(String, String)] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\u{02} \u{1A}"
        
        tableViewData = movie.notEmptyProperties
        
        tableViewSetup()
    }
    
    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.detailTableViewDelegate = self
        tableView.register(UINib(nibName: DetailsTableViewCell.id, bundle: Bundle.main), forCellReuseIdentifier: DetailsTableViewCell.id)
        
        nameLabel.text = movie.title
        
        DataManager.shared.loadImage(url: movie.poster) { [weak self] image in
            guard let image = image else {
                self?.imageView.isHidden = true
                self?.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self?.tableView.frame.width ?? 300, height: self?.nameLabel.frame.height ?? 50)
                self?.tableView.reloadData()
                return
            }
            self?.imageView.image = image
        }
        
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
        
        let view = UIWindow.isLandscape ? navigationController?.navigationBar.subviews[1].subviews[1] : navigationController?.navigationBar.subviews[2].subviews[1]
        
        title = needSetTitle ? movie.title : "\u{02} \u{1A}"
        view?.fadeTransition(0.35, isFromLeftToRight: true)
    }
}
