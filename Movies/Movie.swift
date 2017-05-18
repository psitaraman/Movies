//
//  Movie.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

struct Movie {
    
    // MARK: - Types
    
    private struct Keys {
        static let pageNumber = "page"
        static let totalResults = "total_results"
        static let totalPages = "total_pages"

        static let identifier = "id"
        static let posterPath = "poster_path"
        static let adult = "adult"
        static let overview = "overview"
        static let releaseDate = "release_date"
        static let title = "original_title"
        static let language = "original_language"
        static let backdropPath = "backdrop_path"
        static let popularity = "popularity"
        static let voteCount = "vote_count"
        static let voteAverage = "vote_average"
    }
    
    struct PageData {
        let pageNumber: Int
        let totalResults: Int
        let totalPages: Int
    }
    
    // MARK: - Properties
    
    private static let dateFormatter = DateFormatter(format: "yyyy-MM-dd")
    private static let imageW92RelativePath = "https://image.tmdb.org/t/p/w92"
    private static let imageW154RelativePath = "https://image.tmdb.org/t/p/w154"
    private static let imageW185RelativePath = "https://image.tmdb.org/t/p/w185"
    private static let imageW342RelativePath = "https://image.tmdb.org/t/p/w342"
    private static let imageW500RelativePath = "https://image.tmdb.org/t/p/w500"
    private static let imageW780RelativePath = "https://image.tmdb.org/t/p/w780"
    private static let imageWOriginalRelativePath = "https://image.tmdb.org/t/p/original"
    
    let pageData: PageData
    let identifier: Int
    let isAdult: Bool
    let verboseDescription: String
    let releaseDate: Date?
    let title: String
    let language: String
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double

    let posterImageW92Url: URL?
    let posterImageW154Url: URL?
    let posterImageW185Url: URL?
    let posterImageW342Url: URL?
    let posterImageW500Url: URL?
    let posterImageW780Url: URL?
    let posterImageWOriginalUrl: URL?
    
    var backDropImageW92Url: URL?
    var backDropImageW154Url: URL?
    var backDropImageW185Url: URL?
    var backDropImageW342Url: URL?
    var backDropImageW500Url: URL?
    var backDropImageW780Url: URL?
    var backDropImageWOriginalUrl: URL?

    // MARK: - Lifecycle
    
    init?(dictionary: [String: Any], pageDataDictionary: [String: Any]) {
        
        guard let pageNumber = pageDataDictionary[Movie.Keys.pageNumber] as? Int else { return nil }
        guard let totalResults = pageDataDictionary[Movie.Keys.totalResults] as? Int else { return nil }
        guard let totalPages = pageDataDictionary[Movie.Keys.totalPages] as? Int else { return nil }
        guard let identifier = dictionary[Movie.Keys.identifier] as? Int else { return nil }
        
        self.pageData = PageData(pageNumber: pageNumber, totalResults: totalResults, totalPages: totalPages)
        
        self.identifier = identifier
        self.isAdult = dictionary[Movie.Keys.adult] as? Bool ?? false
        self.verboseDescription = dictionary[Movie.Keys.overview] as? String ?? ""
        
        if let releaseDateString = dictionary[Movie.Keys.releaseDate] as? String {
            self.releaseDate = Movie.dateFormatter.date(from: releaseDateString)
        }else {
            self.releaseDate = nil
        }
        
        
        self.title = dictionary[Movie.Keys.title] as? String ?? ""
        self.language = dictionary[Movie.Keys.language] as? String ?? ""
        self.popularity = dictionary[Movie.Keys.popularity] as? Double ?? 0.0
        self.voteCount = dictionary[Movie.Keys.voteCount] as? Int ?? 0
        self.voteAverage = dictionary[Movie.Keys.voteAverage] as? Double ?? 0.0
        
        if let posterImageString = dictionary[Movie.Keys.posterPath] as? String {
            self.posterImageW92Url = URL(string: "\(Movie.imageW92RelativePath)\(posterImageString)")
            self.posterImageW154Url = URL(string: "\(Movie.imageW154RelativePath)\(posterImageString)")
            self.posterImageW185Url = URL(string: "\(Movie.imageW185RelativePath)\(posterImageString)")
            self.posterImageW342Url = URL(string: "\(Movie.imageW342RelativePath)\(posterImageString)")
            self.posterImageW500Url = URL(string: "\(Movie.imageW500RelativePath)\(posterImageString)")
            self.posterImageW780Url = URL(string: "\(Movie.imageW780RelativePath)\(posterImageString)")
            self.posterImageWOriginalUrl = URL(string: "\(Movie.imageWOriginalRelativePath)\(posterImageString)")
        } else {
            self.posterImageW92Url = nil
            self.posterImageW154Url = nil
            self.posterImageW185Url = nil
            self.posterImageW342Url = nil
            self.posterImageW500Url = nil
            self.posterImageW780Url = nil
            self.posterImageWOriginalUrl = nil
        }

        
        if let backDropImageString = dictionary[Movie.Keys.backdropPath] as? String {
            self.backDropImageW92Url = URL(string: "\(Movie.imageW92RelativePath)\(backDropImageString)")
            self.backDropImageW154Url = URL(string: "\(Movie.imageW154RelativePath)\(backDropImageString)")
            self.backDropImageW185Url = URL(string: "\(Movie.imageW185RelativePath)\(backDropImageString)")
            self.backDropImageW342Url = URL(string: "\(Movie.imageW342RelativePath)\(backDropImageString)")
            self.backDropImageW500Url = URL(string: "\(Movie.imageW500RelativePath)\(backDropImageString)")
            self.backDropImageW780Url = URL(string: "\(Movie.imageW780RelativePath)\(backDropImageString)")
            self.backDropImageWOriginalUrl = URL(string: "\(Movie.imageWOriginalRelativePath)\(backDropImageString)")
        } else {
            self.backDropImageW92Url = nil
            self.backDropImageW154Url = nil
            self.backDropImageW185Url = nil
            self.backDropImageW342Url = nil
            self.backDropImageW500Url = nil
            self.backDropImageW780Url = nil
            self.backDropImageWOriginalUrl = nil
        }
    }
}

// MARK: - Conform to Equatable Protocol

extension Movie: Equatable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}



