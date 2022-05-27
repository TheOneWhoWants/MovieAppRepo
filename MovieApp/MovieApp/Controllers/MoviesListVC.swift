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
    var movieId: [Int] = [1890]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON {
            self.moviesTableView.reloadData()
            print(self.jsonData)
        }
        
        moviesTableView.rowHeight = self.view.frame.height/4
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = #colorLiteral(red: 0.07087678462, green: 0.1643480957, blue: 0.2652850151, alpha: 1)
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = #colorLiteral(red: 0.07087678462, green: 0.1643480957, blue: 0.2652850151, alpha: 1)
            tabBarController?.tabBar.standardAppearance = tabBarAppearance
            tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        
        self.moviesTableView.rowHeight = self.view.frame.height/5
    }
    
//https://image.tmdb.org/t/p/original/gz66EfNoYPqHTYI4q9UEN4CbHRc.png
    
    func getJSON(completed: @escaping () -> ()) {
            let uniqueNumbers = Int.getUniqueRandomNumbers(min: 11, max: 1000000, count: 10)
            for i in uniqueNumbers {
                let url = URL(string: "https://api.themoviedb.org/3/movie/\(i)?api_key=b67ccdefd07e39bde2dc63f29f28e831&language=en-US")
                URLSession.shared.dataTask(with: url!) { data, response, error in
                    if error == nil {
                        let decoder = JSONDecoder()
                        do {
                            let data = try decoder.decode(Movie.self, from: data!)
                            if data.adult == false {
                                self.jsonData.append(data)
                            }
                            DispatchQueue.main.async {
                                completed()
                            }
                        } catch {
                            print(error)
                        }
                    }
                }.resume()
            }
    }
}

extension MoviesListVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = jsonData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCellid", for: indexPath) as! MovieListTBC
        cell.setData(data: cellData)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > moviesTableView.contentSize.height-100-scrollView.frame.height {
            getJSON {
                self.moviesTableView.reloadData()
            }
        }
    }
    
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension Int {
    static func getUniqueRandomNumbers(min: Int, max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert(Int.random(in: min...max))
        }
        return Array(set)
    }
}
