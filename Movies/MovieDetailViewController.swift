//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/18/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voterAverageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties
    
    var imageDataSource = ImageDataSource()
    var movie: Movie!
    var movieDetails: MovieDetails!
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    // MARK: - Private
    
    private func setup() {
        
        let movieViewModel = MovieCellViewModel(movie: self.movie)
        if let url = self.movie.backDropImageW342Url {
            self.imageDataSource.imageWith(url: url, for: IndexPath(row: 0, section: 0)) {[weak self](image, _) in
                Thread.executeOnMainThread {
                    self?.backDropImageView.image = image
                }
            }
        }
        
        if let url = self.movie.posterImageW342Url {
            self.imageDataSource.imageWith(url: url, for: IndexPath(row: 1, section: 0)) {[weak self](image, _) in
                Thread.executeOnMainThread {
                    self?.posterImageView.image = image
                }
            }
        }
    
        self.titleLabel.text = movieViewModel.titleText
        self.languageLabel.text = movieViewModel.languageText
        self.popularityLabel.text = movieViewModel.popularityText
        self.voterAverageLabel.text = movieViewModel.voterAverageText
        self.releaseDateLabel.text = movieViewModel.releaseDateText
        self.runtimeLabel.text = "Runtime: \(self.movieDetails.runtime) min"
        self.revenueLabel.text = "Revenue: $\(self.movieDetails.revenue)"
        self.budgetLabel.text = "Budget: $\(self.movieDetails.budget)"
        self.descriptionTextView.text = "\(self.movie.verboseDescription)"
    }
}
