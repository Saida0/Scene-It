import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var mediaTypeLabel: UILabel!
    var downloadTask: URLSessionDownloadTask?

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(for result: SearchResult) {
        titleLabel.text = result.film
        mediaTypeLabel.text = result.type
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let modifiedDate = dateFormatter.date(from: result.date_released)!
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        releaseDateLabel.text = "Release Date: \(dateFormatter.string(from: modifiedDate))"
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        
        posterImageView.image = UIImage(systemName: "questionmark")
        if let imageURL = URL(string: baseUrl + result.posterImage) {
        downloadTask = posterImageView.loadImage(url: imageURL)
        }
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      downloadTask?.cancel()
      downloadTask = nil
    }

}
