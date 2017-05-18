//
//  ImageDataSource.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import UIKit

final class ImageDataSource {
    
    // Properties
    
    let imageCache = NSCache<NSString, UIImage>() // key is hashed image url so that it is unique
    
    //TODO: - Create another cache that maps hashed image urls to their respective index paths where the section = api page number - This will provide more efficent use of memory by windowing the data more effectively and releasing old images from cache
    
    init() {
        
    }
    
    // MARK: - Public
    
    func imageWith(url: URL, for indexPath: IndexPath, completion: @escaping (UIImage, IndexPath) -> ()) {
        
        //first check cache if image is there
        guard let image = self.imageCache.object(forKey: self.transform(url: url)) else {
            // retrieve image from network if not in cache
            self.downloadImage(url: url, for: indexPath, completion: completion)
            return
        }
        
        Thread.executeOnMainThread {
            completion(image, indexPath)
        }
    }
    
    func prefetchImageWith(url: URL, for indexPath: IndexPath) {
        guard self.imageCache.object(forKey: self.transform(url: url)) == nil else { return }
        self.downloadImage(url: url, for: indexPath, completion: nil)
    }
    
    func removeFromCacheImageWith(url: URL) {
        let key = self.transform(url: url)
        guard self.imageCache.object(forKey: key) != nil else { return }
        self.imageCache.removeObject(forKey: key)
    }
    
    func clearCache() {
        self.imageCache.removeAllObjects()
    }
    
    // MARK: - Private
    
    private func transform(url: URL) -> NSString {
        return url.absoluteString.sha256() as NSString
    }
    
    private func downloadImage(url: URL, for indexPath: IndexPath, completion: ((UIImage, IndexPath) -> ())?) {
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let imageData = data  else { return }
            Thread.executeOnMainThread {
                guard let image = UIImage(data: imageData) else { return }
                // store image in cache then return it back in completion block
                self.imageCache.setObject(image, forKey: self.transform(url: url))
                
                completion?(image, indexPath)
            }
        }
        task.resume()
    }
}
