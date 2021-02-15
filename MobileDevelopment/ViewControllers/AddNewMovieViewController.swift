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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    
    weak var delegate: AddNewMovieViewControllerDelegate?
    
    private let yearValidator = Validator(of: .year)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        registerKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//
//    private func registerKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillShow(notification:)),
//                                               name: UIResponder.keyboardWillShowNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillHide(notification:)),
//                                               name: UIResponder.keyboardWillHideNotification,
//                                               object: nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
//        let keyboardSize = keyboardInfo.cgRectValue.size
//        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//    }

//    @objc func keyboardWillHide(notification: NSNotification) {
//        scrollView.contentInset = .zero
//        scrollView.scrollIndicatorInsets = .zero
//    }
    
    @IBAction func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        
        nameTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
    }
    
    
    @IBAction func didPressSaveButton(_ sender: UIButton) {
        
        yearValidator.isValide(yearTextField.text ?? yearTextField.placeholder ?? "", forceExit: true) { result in
            
            switch result {
            case .valid:
                print("OK")
            case .notValid(criteria: let criteria):
                print(criteria.errorDescription)
            case .notValides(criterias: let criterias):
                print(criterias.reduce("") { $0 + $1.errorDescription})
            }
        }
        
        let movie = Movie(title: nameTextField.text ?? "", year: yearTextField.text ?? "", imdbID: "", type: typeTextField.text ?? "", poster: "", rated: nil, released: nil, production: nil, runtime: nil, genre: nil, director: nil, writer: nil, actors: nil, plot: nil, language: nil, country: nil, awards: nil, imdbRating: nil, imdbVotes: nil)
        
        
        navigationController?.dismiss(animated: true) {
            
            self.delegate?.saveNewMovie(movie)
        }
    }
}
