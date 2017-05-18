//
//  FetchMovieDetails.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

final class FetchMovieDetails: MovieDBRequest {
    
    // MARK: - Properties
    
    private var completionHandler: (MovieDetails?, Error?) -> ()
    
    // MARK: - Lifecycle
    
    init(movieId: String, completion: @escaping (MovieDetails?, Error?) -> ()) {        
        self.completionHandler = completion
        super.init(path: "movie/\(movieId)", queryItems: [])
    }
    
    override func didFinishDataTaskWithData(_ data: MovieDBRequest.ResponseData) {
        
        guard let jsonData = data.data else {
            
            if let error = data.error {
                completionHandler(nil , error)
                return
            }
            
            completionHandler(nil, nil)
            return
        }
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                completionHandler(nil, nil)
                return
            }
            
            guard let movieDetails = MovieDetails(dictionary: json) else {
                completionHandler(nil, nil)
                return
            }
            
            completionHandler(movieDetails, nil)
        } catch {
            // json not parsable
            completionHandler(nil, nil)
        }
    }
}
