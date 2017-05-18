//
//  MoviesViewController.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import UIKit

final class MoviesViewController: UITableViewController {
    
    //MARK: - Properties
    
    private lazy var searchController: UISearchController = {
        // initalize search controller without any inital search results
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = false
        return search
    }()
    
    fileprivate var searchBar: UISearchBar {
        return self.searchController.searchBar
    }
    
    fileprivate let imageDataSource = ImageDataSource()
    
    fileprivate var movies = [Movie]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.prefetchDataSource = self
        
        self.tableView.tableFooterView = UIView()
        
        self.configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        self.imageDataSource.clearCache()
    }
    
    // MARK: - Private
    
    private func configureSearchController() {
        self.definesPresentationContext = true
        
        // configure search bar        
        self.searchBar.placeholder = LocalizedStrings.MovieSearchBar.placeholderText
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = .search
        self.tableView.tableHeaderView = self.searchBar
        self.searchBar.sizeToFit()
    }
    
    fileprivate func showErrorMessage(_ message: String) {
        Thread.executeOnMainThread {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedStrings.Alert.genericCTAOK, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func reloadTableView(animate: Bool = true) {
        Thread.executeOnMainThread {
            guard animate else {
                self.tableView.reloadData()
                return
            }
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    fileprivate func fetchMovies(query: String, forPage pageNumber: Int) {
        
        _ = FetchMovies(query: query, pageNumber: pageNumber) {(movies, error) in
            if let _ = error {
                self.showErrorMessage(LocalizedStrings.Error.genericErrorMessage)
                return
            }
            
            defer {
                if pageNumber == 1 {
                    // replace all movies
                    self.movies = movies
                    self.reloadTableView()
                } else {
                    // append movies
                    self.movies.append(contentsOf: movies)
                    self.reloadTableView(animate: false)
                }
            }
            
            guard movies.isEmpty else { return }
            self.showErrorMessage(LocalizedStrings.Error.noItemsFoundMessage)
        }
    }
    
    // MARK: - Table view data source methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseId, for: indexPath) as! MovieCell
        
        let movie = self.movies[indexPath.row]
        cell.configureCell(movieViewModel: MovieCellViewModel(movie: movie))
        cell.posterIdentifier = indexPath
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! MovieCell
        
        let movie = self.movies[indexPath.row]
        guard let imageUrl = movie.posterImageW185Url else { return }
        self.imageDataSource.imageWith(url: imageUrl, for: indexPath) {(image, imageIndexPath) in
            if cell.posterIdentifier == imageIndexPath {
                Thread.executeOnMainThread {
                    cell.posterImageView.image = image
                }
            }
        }
    }
    
    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row < self.movies.count else { return }
        let movie = self.movies[indexPath.row]
        _ = FetchMovieDetails(movieId: String(describing: movie.identifier)) { (details, error) in
            Thread.executeOnMainThread {
                
                guard let movieDetails = details else { return }
                // present detail screen
                let movieDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
                movieDetailViewController.movie = movie
                movieDetailViewController.movieDetails = movieDetails
                self.navigationController?.pushViewController(movieDetailViewController, animated: true)
            }
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching methods

extension MoviesViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            let movie = self.movies[indexPath.row]
            // prefetch images
            if let imageUrl = movie.posterImageW185Url {
                self.imageDataSource.prefetchImageWith(url: imageUrl, for: indexPath)
            }
            
            // load next page of data (if available) if currently prefetching last indexpath in movie array
            let currentPageNumber = movie.pageData.pageNumber
            if let searchText = self.searchBar.text, !searchText.isEmpty, indexPath.row == self.movies.count - 1, currentPageNumber < movie.pageData.totalPages {
                self.fetchMovies(query: searchText, forPage: currentPageNumber + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row < self.movies.count {
                let movie = self.movies[indexPath.row]
                // remove cached images to reduce memory footprint
                if let imageUrl = movie.posterImageW185Url {
                    self.imageDataSource.removeFromCacheImageWith(url: imageUrl)
                }
            }
        }
    }
}

// MARK: - UISearchBarDelegate methods

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        self.fetchMovies(query: searchText, forPage: 1)
    }
}


