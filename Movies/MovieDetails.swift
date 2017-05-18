//
//  MovieDetails.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

struct MovieDetails {
    
    // MARK: - Types
    
    private struct Keys {
        static let genres = "genres"
        static let name = "name"
        static let homepage = "homepage"
        static let status = "status"
        static let productionCompanies = "production_companies"
        static let productionCountries = "production_countries"
        static let spokenLanguages = "spoken_languages"
        static let identifier = "id"
        static let budget = "budget"
        static let revenue = "revenue"
        static let runtime = "runtime"
    }
    
    // MARK: - Properties
    
    let identifier: Int
    let budget: Int
    let revenue: Int
    let runtime: Int
    let status: String
    let homepage: String
    let genres: [String]
    let productionCompanies: [String]
    let productionCountries: [String]
    let spokenLanguages: [String]
    
    // MARK: - Lifecycle
    
    init?(dictionary: [String: Any]) {
        
        guard let identifier = dictionary[MovieDetails.Keys.identifier] as? Int else { return nil }
        
        self.identifier = identifier
        self.budget = dictionary[MovieDetails.Keys.budget] as? Int ?? 0
        self.revenue = dictionary[MovieDetails.Keys.revenue] as? Int ?? 0
        self.runtime = dictionary[MovieDetails.Keys.runtime] as? Int ?? 0
        self.status = dictionary[MovieDetails.Keys.status] as? String ?? ""
        self.homepage = dictionary[MovieDetails.Keys.homepage] as? String ?? ""
        
        var genreArr = [String]()
        if let genreArray = dictionary[MovieDetails.Keys.genres] as? [[String: Any]] {
            for genre in genreArray {
                if let genreName = genre[MovieDetails.Keys.name] as? String {
                    genreArr.append(genreName)
                }
            }
        }
        self.genres = genreArr
        
        var prodCompArr = [String]()
        if let productionCompaniesArray = dictionary[MovieDetails.Keys.productionCompanies] as? [[String: Any]] {
            for productionCompany in productionCompaniesArray {
                if let productionCompanyName = productionCompany[MovieDetails.Keys.name] as? String {
                    prodCompArr.append(productionCompanyName)
                }
            }
        }
        self.productionCompanies = prodCompArr
        
        var prodCountriesArr = [String]()
        if let prodCountryArray = dictionary[MovieDetails.Keys.productionCountries] as? [[String: Any]] {
            for prodCountry in prodCountryArray {
                if let prodCountryName = prodCountry[MovieDetails.Keys.name] as? String {
                    prodCountriesArr.append(prodCountryName)
                }
            }
        }
        self.productionCountries = prodCountriesArr
        
        var spokenLanguagesArr = [String]()
        if let spokenLanguagesArray = dictionary[MovieDetails.Keys.spokenLanguages] as? [[String: Any]] {
            for spokenLanguage in spokenLanguagesArray {
                if let spokenLanguageName = spokenLanguage[MovieDetails.Keys.name] as? String {
                    spokenLanguagesArr.append(spokenLanguageName)
                }
            }
        }
        self.spokenLanguages = spokenLanguagesArr
    }
}

// MARK: - Conform to Equatable Protocol

extension MovieDetails: Equatable {
    static func ==(lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

