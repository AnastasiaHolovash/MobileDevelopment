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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - AddNewMovieViewControllerDelegate
    
    weak var delegate: AddNewMovieViewControllerDelegate?
    
    // MARK: - Variables and properties
    
    private let yearValidator = Validator(of: .year)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                for: .editingChanged)
        nameTextField.delegate = self
        yearTextField.delegate = self
        typeTextField.delegate = self
    }
    
    // MARK: - objc
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        yearValidator.isValid(textField.text ?? textField.placeholder ?? "", forceExit: true) { [weak self] result in
            
            switch result {
            case .valid:
                self?.yearLabel.text = "year"
                self?.yearLabel.textColor = .placeholderText
                self?.saveButton.isUserInteractionEnabled = true
                self?.saveButton.tintColor = .systemBlue
                
            case .notValid(criteria: let criteria):
                self?.yearLabel.text = criteria.errorDescription
                self?.yearLabel.textColor = .systemRed
                self?.saveButton.isUserInteractionEnabled = false
                self?.saveButton.tintColor = .placeholderText
                
            case .notValides(criterias: let criterias):
                self?.yearLabel.text = criterias.reduce("") { $0 + $1.errorDescription }
                self?.yearLabel.textColor = .systemRed
                self?.saveButton.isUserInteractionEnabled = false
                self?.saveButton.tintColor = .placeholderText
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        
        nameTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
    }
    
    @IBAction func didPressSaveButton(_ sender: UIButton) {
        
        let name = !nameTextField.text!.isEmpty ? nameTextField.text! : nameTextField.placeholder!
        let year = !yearTextField.text!.isEmpty ? yearTextField.text! : yearTextField.placeholder!
        let type = !typeTextField.text!.isEmpty ? typeTextField.text! : typeTextField.placeholder!
        
        let movie = Movie(title: name, year: year, imdbID: "noId", type: type, poster: "", rated: nil, released: nil, production: nil, runtime: nil, genre: nil, director: nil, writer: nil, actors: nil, plot: nil, language: nil, country: nil, awards: nil, imdbRating: nil, imdbVotes: nil)
        
        delegate?.saveNewMovie(movie)
        navigationController?.popViewController(animated: true)
    }
}

extension AddNewMovieViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            yearTextField.becomeFirstResponder()
            
        } else if textField == yearTextField {
            typeTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
