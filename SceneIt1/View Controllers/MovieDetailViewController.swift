import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var watchedButton: UIButton!
    @IBOutlet weak var currentlyWatchingButton: UIButton!
    @IBOutlet weak var wantToWatchButton: UIButton!
    
    var movie: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if movie != nil {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel.text = movie.film
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let modifiedDate = dateFormatter.date(from: movie.date_released)!
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        releaseDateLabel.text = "Release Date: \(dateFormatter.string(from: modifiedDate))"
        
        languageLabel.text = "Language: \((movie.language).lowercased())"
        descriptionLabel.text = movie.about
        
        // Get poster image
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        posterImageView.image = UIImage(systemName: "questionmark")
        if let imageURL = URL(string: baseUrl + movie.posterImage) {
            downloadTask = posterImageView.loadImage(url: imageURL)
        }
        
        // Get backdrop image
        let backdropBaseUrl = "https://image.tmdb.org/t/p/original"
        backdropImageView.image = UIImage(systemName: "questionmark")
        if let imageURL = URL(string: backdropBaseUrl + movie.backdropImage) {
            downloadTask = backdropImageView.loadImage(url: imageURL)
        }
    }
    
    func addMovie(tag: String) {
        let movieItem = MovieItem(context: PersistenceService.context)
        movieItem.title = movie.film
        movieItem.language = movie.language
        movieItem.overview = movie.about
        movieItem.media_type = movie.release_date
        movieItem.poster = movie.poster_path
        movieItem.movie_tag = tag
        PersistenceService.saveContext()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("Saving to 'Currently Watching'")
            addMovie(tag: "1")
            print("Refreshing bookmarkVC...")
        case 2:
            print("Saving to 'Want To Watch'")
            addMovie(tag: "2")
            print("Refreshing bookmarkVC..")
        case 3:
            print("Saving to 'Watched'")
            addMovie(tag: "3")
            print("Refreshing bookmarkVC...")
        default:
            print("Default")
        }
    
        navigationController?.popViewController(animated: true)
    }
}
