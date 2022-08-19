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
    var json: RequestRespond?
    var jsonData: [Movie] = []
    var cellData: [MovieCell] = []
    var movieId: [Int] = [1890]
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.createSpinnerView(frame: self)
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
    
    override func viewDidAppear(_ animated: Bool) {
//        self.activityIndicator.view.backgroundColor = #colorLiteral(red: 0.07087678462, green: 0.1643480957, blue: 0.2652850151, alpha: 1)
//        self.activityIndicator.createSpinnerView(frame: self)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.moviesTableView.reloadData()
//            self.activityIndicator.deleteSpinerView()
//        }
    }
    
    
//https://image.tmdb.org/t/p/original/gz66EfNoYPqHTYI4q9UEN4CbHRc.png
    
    func getJSON(completed: @escaping () -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=b67ccdefd07e39bde2dc63f29f28e831&language=en-US&page=\(page.description)")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(RequestRespond.self, from: data!)
                    print("DATA + \(data)")
                    for i in data.results! {
                        if i.adult == false {
                            self.jsonData.append(i)
                        }
                    }
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        
        
        
//            let uniqueNumbers = Int.getUniqueRandomNumbers(min: 11, max: 1000000, count: 10)
//            for i in uniqueNumbers {
////                let url = URL(string: "https://api.themoviedb.org/3/movie/\(i)?api_key=b67ccdefd07e39bde2dc63f29f28e831&language=en-US")
//            }
        self.page += 1
    }
    
}

extension MoviesListVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCellid", for: indexPath) as! MovieListTBC
        if indexPath.row < jsonData.count {
            let cellData = jsonData[indexPath.row]
            cell.setData(data: cellData)
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
                if indexPath == lastVisibleIndexPath {
                    activityIndicator.deleteSpinerView()
                }
            }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > moviesTableView.contentSize.height-100-scrollView.frame.height {
            self.jsonData.removeAll()
            getJSON {
                self.moviesTableView.reloadData()
            }
        }
    }
}

//
//extension UIImageView {
//    func loadImage(urlString: String) {
//        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
//            self.image = image
//            return
//        }
//
//        guard let url = URL(string: urlString) else {return}
//
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                      DispatchQueue.main.async {
//imageCache.setObject(image, forKey: url.absoluteString as NSString)
//self?.image = image
//}
//                }
//            }
//        }
//    }
//}

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        
//        guard let url = URL(string: url) else {return}
        
        if let image = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage{
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
           
            DispatchQueue.main.async {  [weak self] in
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
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

