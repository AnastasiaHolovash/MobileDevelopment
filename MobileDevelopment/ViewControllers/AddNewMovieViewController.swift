//
//  AddNewMovieViewController.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 15.02.2021.
//

import UIKit

protocol AddNewMovieViewControllerDelegate: class {
    
    func saveNewMovie(_ movie: Movie)
}

class AddNewMovieViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    weak var delegate: AddNewMovieViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func didPressSaveButton(_ sender: UIButton) {
        
        // TODO: - Add validation for year
        
        let movie = Movie(title: nameTextField.text ?? "", year: yearTextField.text ?? "", imdbID: "", type: typeTextField.text ?? "", poster: "", rated: nil, released: nil, production: nil, runtime: nil, genre: nil, director: nil, writer: nil, actors: nil, plot: nil, language: nil, country: nil, awards: nil, imdbRating: nil, imdbVotes: nil)
        
        
        navigationController?.dismiss(animated: true) {
            
            self.delegate?.saveNewMovie(movie)
        }
    }
}
