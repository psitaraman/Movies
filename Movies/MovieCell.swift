//
//  MovieCell.swift
//  Movies
//
//  Created by Praveen Sitaraman on 5/17/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import UIKit

final class MovieCell: UITableViewCell {
    
    // MARK: - IBoutlets

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voterAverageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // MARK: - Properties
    
    static let reuseId = String(describing: MovieCell.self)
    var posterIdentifier: IndexPath!
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.posterImageView.image = nil
        self.titleLabel.text = nil
        self.languageLabel.text = nil
        self.popularityLabel.text = nil
        self.voterAverageLabel.text = nil
        self.releaseDateLabel.text = nil
    }
    
    // MARK: - Public
    
    func configureCell(movieViewModel: MovieCellViewModel) {
        
        self.titleLabel.text = movieViewModel.titleText
        self.languageLabel.text = movieViewModel.languageText
        self.popularityLabel.text = movieViewModel.popularityText
        self.voterAverageLabel.text = movieViewModel.voterAverageText
        self.releaseDateLabel.text = movieViewModel.releaseDateText
    }
}
