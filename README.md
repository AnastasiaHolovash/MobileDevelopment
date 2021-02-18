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
    Лабораторна робота №4
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
(8206 mod 2) + 1 = 1

## Результати роботи додатка



## Лістинг коду

#### Movie.swift
```swift
// MARK: - Search

struct Search: Codable {
    
    let search: [Movie]

    enum CodingKeys: String, CodingKey {
        
        case search = "Search"
    }
}

// MARK: - Movie

struct Movie: Codable, Equatable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    let rated, released, production: String?
    let runtime, genre, director, writer: String?
    let actors, plot, language, country: String?
    let awards, imdbRating, imdbVotes: String?

    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case production = "Production"
    }
    
    var notEmptyProperties: [(String, String)] {
        
        get {
            let allProperties: [(String, String?)] = [
                ("Year: ", year),
                ("Type: ", type),
                ("Rated: ", rated),
                ("Released: ", released),
                ("Runtime: ", runtime),
                ("Genre: ", genre),
                ("Production: ", production),
                ("Director: ", director),
                ("Writer: ", writer),
                ("Actors: ", actors),
                ("Plot: ", plot),
                ("Language: ", language),
                ("Country: ", country),
                ("Awards: ", awards),
                ("Poster: ", poster),
                ("imdbRating: ", imdbRating),
                ("imdbVotes: ", imdbVotes),]
            
            var result: [(String, String)] = []
            
            allProperties.forEach { (name, item) in
                if let item = item, !item.isEmpty {
                    result.append((name, item))
                }
            }
            
            return result
        }
    }
}

```

#### MoviesViewController.swift

```swift
import UIKit

final class MoviesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private variables and properties
    
    private var moviesData: [Movie] = []
    private var filteredMoviesData: [Movie] = []
    
    private var searchController: UISearchController!
    private var keyboardHandler: KeyboardEventsHandler!
    
    private let moviesDataManager = MoviesDataManager.shared
    private let tableViewPlaceholder = UIImage(named: "Placeholder")!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        searchControllerSetup()
        
        keyboardHandler = KeyboardEventsHandler(forView: view, scroll: tableView)
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
        searchController.delegate = self
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard let itemToRemoveIndex = searchController.isActive ?  moviesData.firstIndex(of: filteredMoviesData[indexPath.row]) : indexPath.row else {
                return
            }
            moviesData.remove(at: itemToRemoveIndex)
            if searchController.isActive {
                filteredMoviesData.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension MoviesViewController: UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {

        tableView.removePlaceholder()
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
        if filteredMoviesData.isEmpty {
            tableView.addPlaceholder(image: tableViewPlaceholder)
        } else {
            tableView.removePlaceholder()
        }
        tableView.reloadData()
        searchController.searchBar.isLoading = false
    }
}

// MARK: - UISearchBarDelegate

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.isLoading = false
        tableView.reloadData()
        tableView.removePlaceholder()
    }
}

// MARK: - AddNewMovieViewControllerDelegate

extension MoviesViewController: AddNewMovieViewControllerDelegate {
    
    func saveNewMovie(_ movie: Movie) {
        moviesData.append(movie)
        tableView.reloadData()
    }
}

```

#### DetailsViewController.swift

```swift
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
        
        if let image = MoviesDataManager.shared.fetchMovieImage(for: movie.poster) {
            imageView.image = image
        } else {
            imageView.isHidden = true
            tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: nameLabel.frame.height)
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

```

#### DetailsViewController.swift

```swift
import UIKit

protocol AddNewMovieViewControllerDelegate: class {
    
    func saveNewMovie(_ movie: Movie)
}

final class AddNewMovieViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - AddNewMovieViewControllerDelegate
    
    weak var delegate: AddNewMovieViewControllerDelegate?
    
    // MARK: - Variables and properties
    
    private let yearValidator = Validator(of: .year)
    private var keyboardHandler: KeyboardEventsHandler!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardHandler = KeyboardEventsHandler(forView: view, scroll: scrollView)
        
        yearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                for: .editingChanged)
        nameTextField.delegate = self
        yearTextField.delegate = self
        typeTextField.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        scrollView.setContentOffset(.zero, animated: true)

        navigationItem.largeTitleDisplayMode = .always
        coordinator.animate(alongsideTransition: { (_) in
            self.navigationController?.navigationBar.sizeToFit()
        }, completion: nil)
    }
    
    // MARK: - @objc
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        
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

```

## Висновок

Під час виконання лабораторної роботи було покращено навички зі створення мобільних додатків для операційної системи iOS. 
У даній роботі було розширено функціонал із попередньої. За допомогою UITableViewDataSource, UITableViewDelegate, UISearchBar, UISearchBarDelegate, UILabel, UIImageView, UITextField, UIButton було створено UIViewController для відображення детальної інформації про сутність - Movie, реалізовано пошук по назві сутності та можливість додавання нової.
