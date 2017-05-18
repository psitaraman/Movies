//
//  MovieDBRequest.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import Foundation

class MovieDBRequest {
    
    // MARK: - Types
    
    private enum Version: Int {
        case v3 = 3
        case v4 = 4
    }
    
    struct ResponseData {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    struct DownloadData {
        let url: URL?
        let response: URLResponse?
        let error: Error?
    }
    
    // MARK: - Properties
    
    private static let apiKey = "c4fb6d56cf07bb5cadb461b4f3a57c79"
    private static let host = "api.themoviedb.org"
    private static let scheme = "https"
    
    private let requestUrl: URL
    
    // MARK: - Lifecycle
    
    init(path: String, queryItems: [URLQueryItem]) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = MovieDBRequest.scheme
        urlComponents.host = MovieDBRequest.host
        
        let urlPath = "/\(Version.v3.rawValue)/\(path)"
        urlComponents.path = urlPath
        
        var urlQueryItems = queryItems
        urlQueryItems.append(URLQueryItem(name: "language", value: "en-US"))
        urlQueryItems.append(URLQueryItem(name: "api_key", value: MovieDBRequest.apiKey))
        urlComponents.queryItems = urlQueryItems
        
        // should crash if url is not valid, url should always be valid
        self.requestUrl = urlComponents.url!
        
        self.executeRequest(asDownloadTask: false)
    }
    
    // MARK: - Abstract methods
    
    func didFinishDataTaskWithData(_ data: ResponseData) {
        // implement in subclass
    }
    
    func didFinishDownloadTaskWithData(_ data: DownloadData) {
        // implement in subclass
    }
    
    // MARK: - Private
    
    private func executeRequest(asDownloadTask: Bool) {
        let urlRequest = URLRequest(url: self.requestUrl)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        guard asDownloadTask else {
            let task = session.dataTask(with: urlRequest) {(data, response, error) in
                let responseData = ResponseData(data: data, response: response, error: error)
                self.didFinishDataTaskWithData(responseData)
            }
            task.resume()
            
            return
        }
        
        let task = session.downloadTask(with: urlRequest) {(url, response, error) in
            let downloadData = DownloadData(url: url, response: response, error: error)
            self.didFinishDownloadTaskWithData(downloadData)
        }
        task.resume()
    }
}
