import UIKit

class SearchMovieViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    var movies = [SearchResult]() // holds the movies received back from the API repsonse
    var dataTask: URLSessionDataTask?
    var hasSearched = false
    var isLoading = false


    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 54, left: 0, bottom: 0, right: 0)
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(
          cellNib,
          forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(
          nibName: TableView.CellIdentifiers.loadingCell,
          bundle: nil)
        tableView.register(
          cellNib,
          forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    }

    
    // HELPER METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ShowDetail" {
        let movieDetailViewController = segue.destination as! MovieDetailViewController
        let indexPath = sender as! IndexPath
        let movie = movies[indexPath.row]
        movieDetailViewController.movie = movie
      }
    }
    
    func SearchURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(
        withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://api.themoviedb.org/3/search/multi?api_key=04ac0f877abd5b16c52663c9d6fba171&query=\(encodedText)"
        let url = URL(string: urlString)
        return url!
    }
    
    
    func parse(data: Data) -> [SearchResult] {
      do {
          let decoder = JSONDecoder()
          let result = try decoder.decode(ResultArray.self, from: data)
          return result.results
      } catch {
          print("JSON Error: \(error)")
          return []
      }
    }
    
    
    func showNetworkError() {
      let alert = UIAlertController(
        title: "Whoops...",
        message: "There was an error accessing the MovieDB." +
        " Please try again.",
        preferredStyle: .alert)
      
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
} // End Search View Controller


// TABLE VIEW
extension SearchMovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
          return 1
        } else if !hasSearched {
          return 0
        } else if movies.count == 0 {
          return 1
        } else {
          return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
          let cell = tableView.dequeueReusableCell(
            withIdentifier: TableView.CellIdentifiers.loadingCell,
            for: indexPath)
              
          let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
          spinner.startAnimating()
          return cell
        } else
        if movies.count == 0 {
            return tableView.dequeueReusableCell(
            withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
            for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:
            TableView.CellIdentifiers.searchResultCell,
            for: indexPath) as! SearchResultCell

            let movie = movies[indexPath.row]
            cell.configure(for: movie)
            return cell
        }
    }
    
    // Deselects row with animation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
      
    // Allows row selection only if search result is not empty
    func tableView(
        _ tableView: UITableView, willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        if movies.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }

} // End Table View Delegate


// SEARCH BAR
extension SearchMovieViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      performSearch()
    }
    
    func performSearch(){
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            isLoading = true
            tableView.reloadData()

            hasSearched = true
            movies = []

            let url = SearchURL(
              searchText: searchBar.text!)
            let session = URLSession.shared

            let dataTask = session.dataTask(with: url) {data, response, error in
                if let error = error as NSError?, error.code == -999 {
                  return
                } else if let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 {
                    if let data = data {
                      self.movies = self.parse(data: data)
                      DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                      }
                      return
                    }
                } else {
                  print("Failure! \(response!)")
                }
                DispatchQueue.main.async {
                  self.hasSearched = false
                  self.isLoading = false
                  self.tableView.reloadData()
                  self.showNetworkError()
                }
            }
                dataTask.resume()
        }
    }
    
} // End Search Bar Delegate
