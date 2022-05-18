import UIKit
import CoreData

class BookmarkViewController: UIViewController {

    @IBOutlet weak var currentlyWatchingCellView: UICollectionView!
    @IBOutlet weak var wantToWatchCellView: UICollectionView!
    @IBOutlet weak var watchedCellView: UICollectionView!
    
    @IBOutlet weak var currentlyWatchingLabel: UILabel!
    @IBOutlet weak var wantToWatchLabel: UILabel!
    @IBOutlet weak var watchedLabel: UILabel!

    
    var currently_movies = [MovieItem]()
    var want_movies = [MovieItem]()
    var watched_movies = [MovieItem]()
    
    var downloadTask: URLSessionDownloadTask?
    
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabels()
        fetchMovies()
    }
    
    func updateLabels() {
        currentlyWatchingLabel.text = "Currently Watching (\(currently_movies.count))"
        wantToWatchLabel.text = "Want To Watch (\(want_movies.count))"
        watchedLabel.text = "Watched (\(watched_movies.count))"
    }
    
    func fetchMovies() {
        // Fetch data from CoredData to display in collection view
        do {
            let request_currently = MovieItem.fetchRequest() as NSFetchRequest<MovieItem>
            let request_want = MovieItem.fetchRequest() as NSFetchRequest<MovieItem>
            let request_watched = MovieItem.fetchRequest() as NSFetchRequest<MovieItem>
            
            let currently_pred = NSPredicate(format: "movie_tag CONTAINS '1'")
            let want_pred = NSPredicate(format: "movie_tag CONTAINS '2'")
            let watched_pred = NSPredicate(format: "movie_tag CONTAINS '3'")
            
            request_currently.predicate = currently_pred
            request_want.predicate = want_pred
            request_watched.predicate = watched_pred
            
            self.currently_movies = try PersistenceService.context.fetch(request_currently)
            self.want_movies = try PersistenceService.context.fetch(request_want)
            self.watched_movies = try PersistenceService.context.fetch(request_watched)
            
            DispatchQueue.main.async {
                self.currentlyWatchingCellView.reloadData()
                self.wantToWatchCellView.reloadData()
                self.watchedCellView.reloadData()
            }
        } catch {}
        print("Finished refreshing") 
    }
}



extension BookmarkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == currentlyWatchingCellView) {
            return currently_movies.count
        }
        else if (collectionView == wantToWatchCellView) {
            return want_movies.count
        }
        return watched_movies.count    // collectionView ==  watchedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        
        if (collectionView == currentlyWatchingCellView) {
            let cell = currentlyWatchingCellView.dequeueReusableCell(withReuseIdentifier: "CurrentlyWatchingCell", for: indexPath) as! CurrentlyWatchingCollectionViewCell
            cell.titleLabel.text = currently_movies[indexPath.row].title
            
            cell.movieImageView.image = UIImage(systemName: "questionmark")
            if let imageURL = URL(string: baseUrl + currently_movies[indexPath.row].poster!) {
                downloadTask = cell.movieImageView.loadImage(url: imageURL)
            }
            
            return cell
        }
        else if (collectionView == wantToWatchCellView) {
            let cell2 = wantToWatchCellView.dequeueReusableCell(withReuseIdentifier: "WantToWatchCell", for: indexPath) as! WantToWatchCollectionViewCell
            cell2.titleLabel.text = want_movies[indexPath.row].title
            
            cell2.movieImageView.image = UIImage(systemName: "questionmark")
            if let imageURL = URL(string: baseUrl + want_movies[indexPath.row].poster!) {
                downloadTask = cell2.movieImageView.loadImage(url: imageURL)
            }
            return cell2
        }
        // collectionView == watchedCell
        let cell3 = watchedCellView.dequeueReusableCell(withReuseIdentifier: "WatchedCell", for: indexPath) as! WatchedCollectionViewCell
        cell3.titleLabel.text = watched_movies[indexPath.row].title
        
        cell3.movieImageView.image = UIImage(systemName: "questionmark")
        if let imageURL = URL(string: baseUrl + watched_movies[indexPath.row].poster!) {
            downloadTask = cell3.movieImageView.loadImage(url: imageURL)
        }
        return cell3
    }
}
