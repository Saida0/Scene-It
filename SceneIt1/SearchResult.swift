import Foundation
import UIKit

class ResultArray: Codable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [SearchResult]
}


class SearchResult: Codable, CustomStringConvertible {
    let id: Int
    let name: String?
    let title: String?
    let overview: String?
    let release_date: String?
    let first_air_date: String?
    let poster_path: String?
    let backdrop_path: String?
    let media_type: String?
    let original_language: String?
   
    
    var description: String {
        return "\nResult - Media Type: \(type), Film: \(film), Release Date: \(date_released)"
    }
    
    var about: String {
        return overview ?? "(The description for this movie is currently unavailable.)"
    }
    
    var date_released: String {
      return release_date ?? first_air_date ?? "N/A"
    }
    
    var film: String {
      return name ?? title ?? ""
    }
    var language: String {
        return original_language ?? "N/A"
    }

    var posterImage: String {
        return poster_path ?? ""
    }
    
    var backdropImage: String {
        return backdrop_path ?? ""
    }
    
    
    var type: String {
        let media_type = self.media_type
        switch media_type {
        case "movie": return "Movie"
        case "tv": return "TV Series"
        default: break
        }
        return ""
    }
}
