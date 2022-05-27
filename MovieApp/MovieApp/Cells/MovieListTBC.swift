//
//  MovieListTBC.swift
//  MovieApp
//
//  Created by Matthew  on 27.05.2022.
//

import UIKit

class MovieListTBC: UITableViewCell {
    
    @IBOutlet weak var titleMovieImageView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var titleMovieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: Movie) {
        self.titleMovieImageView.layer.cornerRadius = 15
        self.descriptionView.layer.cornerRadius = 15
        self.movieTitle.text = data.title?.description
        self.genreLabel.text = data.genre?[0].name?.description

        if let genre = data.genre {
            self.genreLabel.text = "Genre: \(genre.description)"
        } else {
            self.genreLabel.text = "Genre: unknown"
        }
        
        if let releaseDate = data.release_date {
            self.dateLabel.text = "Release date: \(releaseDate.description)"
        } else {
            self.dateLabel.text = "Release date: UNKNOWN"
        }
        
        if let titleImage = data.poster_path {
            self.titleMovieImage.downloaded(from: "https://image.tmdb.org/t/p/original\(titleImage)")
        } else {
            self.titleMovieImage.image = UIImage(systemName: "slash.circle")
//            rectangle.fill.on.rectangle.fill.slash.fill
        }
    }

}
