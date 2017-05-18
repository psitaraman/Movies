//
//  FetchMovies.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

final class FetchMovies: MovieDBRequest {
    
    // MARK: - Properties
    
    private var completionHandler: ([Movie], Error?) -> ()
    
    // MARK: - Lifecycle
    
    init(query: String, pageNumber: Int = 1, completion: @escaping ([Movie], Error?) -> ()) {
        let encodedQuery = query.addingPercentEncodingForQueryParameter()
        let queryItem = URLQueryItem(name: "query", value: encodedQuery)
        let pageQueryItem = URLQueryItem(name: "page", value: "\(pageNumber)")
        let adultQueryItem = URLQueryItem(name: "include_adult", value: "false")

        self.completionHandler = completion
        super.init(path: "search/movie", queryItems: [queryItem, pageQueryItem, adultQueryItem])
    }
    
    override func didFinishDataTaskWithData(_ data: MovieDBRequest.ResponseData) {
        
        guard let jsonData = data.data else {
            
            if let error = data.error {
                completionHandler([] , error)
                return
            }
            
            completionHandler([], nil)
            return
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                completionHandler([], nil)
                return
            }
            
            guard let movieList = json["results"] as? [[String: Any]] else {
                completionHandler([], nil)
                return
            }
            
            var movieArray = [Movie]()
            for dictionary in movieList {
                if let movie = Movie(dictionary: dictionary, pageDataDictionary: json) {
                    movieArray.append(movie)
                }
            }
            
            completionHandler(movieArray, nil)
        } catch {
            // json not parsable
            completionHandler([], nil)
        }
    }
}
