//
//  MoviesListVC.swift
//  MovieApp
//
//  Created by Matthew  on 26.05.2022.
//

import UIKit

class MoviesListVC: UIViewController {

    @IBOutlet weak var moviesTableView: UITableView!
    
    let activityIndicator = SpinnerViewController()
    var json: Movie?
    var jsonData: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getJSON {
            print(self.json)
        }
        
        self.moviesTableView.rowHeight = self.view.frame.height/5
        
    }
    
    func getJSON(completed: @escaping () -> ()) {
        self.activityIndicator.createSpinnerView(frame: self)
//        guard let postId = postId else {return}
        let url = URL(string: "https://api.themoviedb.org/3/movie/1090?api_key=b67ccdefd07e39bde2dc63f29f28e831&language=en-US")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                do {
                    self.json = try decoder.decode(Movie.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
        self.activityIndicator.deleteSpinerView()
    }
    

}
