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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleMovieImage.image = nil
    }
    
    func setData(data: MovieCell) {
        self.titleMovieImageView.layer.cornerRadius = 15
        self.descriptionView.layer.cornerRadius = 15
        self.movieTitle.text = data.title
        print("GENRE+++ \(String(describing: data.genre))")
        self.dateLabel.text = "Release date: \(data.date.description)"
        self.titleMovieImage = data.titleImageLink.downloaded(from: <#T##URL#>)

    }
    
//    func setData(data: Movie) {
//        self.titleMovieImageView.layer.cornerRadius = 15
//        self.descriptionView.layer.cornerRadius = 15
//        self.movieTitle.text = data.title?.description
//
//        print("GENRE+++ \(String(describing: data.genre_ids))")
//
//        if let releaseDate = data.release_date {
//            self.dateLabel.text = "Release date: \(releaseDate.description)"
//        } else {
//            self.dateLabel.text = "Release date: UNKNOWN"
//        }
//
//        if let titleImage = data.poster_path {
//
//            DispatchQueue.main.async { [weak self] in
//                let urlString = "https://image.tmdb.org/t/p/original\(titleImage)"
//                self?.titleMovieImage.downloaded(from: urlString)
//
//            }
//            print("URL + \(titleImage)")
//        } else {
//            self.titleMovieImage.image = UIImage(systemName: "slash.circle")
//        }
//    }
}
