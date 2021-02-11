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
    Лабораторна робота №3
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

## Скріншоти роботи додатка

<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab3/ImagesLab3/1.png" width="300">
<img src="https://github.com/AnastasiaHolovash/MobileDevelopment/blob/Lab3/ImagesLab3/2.png" height="300">

## Лістинг коду

#### Movie.swift
```swift
import Foundation

// MARK: - Search

struct Search: Codable {
    
    let search: [Movie]

    enum CodingKeys: String, CodingKey {
        
        case search = "Search"
    }
}

// MARK: - Movie

struct Movie: Codable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

```

#### MoviesViewController.swift

```swift
import UIKit

final class MoviesViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private variables
    
    private var moviesData: [Movie] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        
        fetchMovieData(from: "MoviesList")
        tableView.reloadData()
    }
    
    private func tableViewSetup() {
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieTableViewCell.id, bundle: Bundle.main), forCellReuseIdentifier: MovieTableViewCell.id)
    }
    
    // MARK: - Private funcs
    
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

```

## Висновок

Під час виконання лабораторної роботи було покращено навички зі створення мобільних додатків для операційної системи iOS. 
У даній роботі за допомогою UITableView, UITableViewDataSource, UILabel, UIImageView, Codable було створено таблицю,  що відображає сутності - Movie. Дані, представлені у форматі JSON, отримуються з текстового файла.
