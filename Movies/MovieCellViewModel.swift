//
//  MovieCellViewModel.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

struct MovieCellViewModel {
    
    // MARK: - Properties
    
    private static let dateFormatter = DateFormatter(format: "MM/dd/yy")
    
    let titleText: String
    let languageText: String
    let popularityText: String
    let voterAverageText: String
    let releaseDateText: String
    
    // MARK: - Lifecycle
    
    init(movie: Movie) {
        self.titleText = movie.title.capitalized
        self.languageText = LocalizedStrings.Movie.language(movie.language.capitalized)
        self.popularityText = LocalizedStrings.Movie.popularity(movie.popularity)
        self.voterAverageText = LocalizedStrings.Movie.voterAverage(movie.voteAverage)
        
        if let date = movie.releaseDate {
            self.releaseDateText = LocalizedStrings.Movie.releaseDate(MovieCellViewModel.dateFormatter.string(from: date))
        } else {
            self.releaseDateText = ""
        }
    }
}
