//
//  LocalizedStrings.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

struct LocalizedStrings {
    
    struct MovieSearchBar {
        static let placeholderText = NSLocalizedString("searchBar.placeholder.text", comment: "")
    }
    
    struct Movie {
        static func popularity(_ popularity: Double) -> String {
            return String.localizedStringWithFormat(NSLocalizedString("movie.popularity.title", comment: ""), popularity)
        }
        
        static func voterAverage(_ voterAverage: Double) -> String{
            return String.localizedStringWithFormat(NSLocalizedString("movie.voterAverage.title", comment: ""), voterAverage)
        }
        
        static func language(_ language: String) -> String{
            return String.localizedStringWithFormat(NSLocalizedString("movie.language.title", comment: ""), language)
        }
        
        static func releaseDate(_ releaseDate: String) -> String {
            return String.localizedStringWithFormat(NSLocalizedString("movie.releaseDate.title", comment: ""), releaseDate)
        }
    }
    
    struct Error {
        static let genericErrorMessage = NSLocalizedString("error.generic.message", comment: "")
        static let noItemsFoundMessage = NSLocalizedString("error.noItemsFound.message", comment: "")
    }
    
    struct Alert {
        static let genericCTAOK = NSLocalizedString("alert.cta.ok", comment: "")
    }
}
