//
//  HomeViewController.swift
//  Movies
//
//  Created by Ken Lâm on 10/14/16.
//  Copyright © 2016 Ken Lam. All rights reserved.
//

import UIKit
import AFNetworking

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var endPoint: String!
    var refreshControl = UIRefreshControl()
    var movies = [NSDictionary]()
    var isLoading = false
    var page = 1
    var totalPages = 1
    let LAYOUT_LIST = 1
    let LAYOUT_GRID = 2
    var layoutType = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(MovieViewController.refreshData), for: UIControlEvents.valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        
        fetchData(page: page)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData(page: Int) {
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: moviesTableView.contentSize.width, height: 60))
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        moviesTableView.tableFooterView = tableFooterView
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint!)?api_key=\(apiKey)&page=\(page)")
        if let url = url {
            let request = URLRequest(
                url: url,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main)
            let task = session.dataTask(
                with: request,
                completionHandler: { (dataOrNil, response, error) in
                    self.refreshControl.endRefreshing()
                    loadingView.stopAnimating()
                    
                    if error != nil {
                        print("KenK11 \(error?.localizedDescription)")
                        self.showError(error: (error?.localizedDescription)!)
                    }
                    
                    if let data = dataOrNil {
                        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.isLoading = false
                            if let moviesData = responseDictionary["results"] as? [NSDictionary] {
                                if page == 1 {
                                    self.movies = moviesData
                                    self.totalPages = responseDictionary.value(forKey: "total_pages") as! Int
                                } else {
                                    for movie in moviesData {
                                        self.movies.append(movie)
                                    }
                                }
                                self.moviesTableView.reloadData()
                            }
                        }
                    }
            })
            task.resume()
        }
    }
    
    func refreshData() {
        page = 1
        fetchData(page: 1)
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Error networking", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieViewCell
        let movie = movies[indexPath.row]
        let poster = "https://image.tmdb.org/t/p/w342\(movie.value(forKey: "poster_path") as? String ?? "")"
        cell.titleLabel.text = (movie.value(forKey: "title") as! String)
        cell.posterImageView.setImageWith(URL(string: poster)!)
        cell.accessoryType = UITableViewCellAccessoryType.none
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isLoading) {
            let scrollViewContentHeight = moviesTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - moviesTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && moviesTableView.isDragging && page < totalPages) {
                isLoading = true
                page += 1
                fetchData(page: page)
            }
        }
    }
    
    
    @IBAction func changeLayout(_ sender: AnyObject) {
        print("KenK11")
        
        switch layoutType {
        case LAYOUT_LIST:
            layoutType = LAYOUT_GRID
            navigationItem.leftBarButtonItem?.image = UIImage(named: "ic_view_list")
            break
        case LAYOUT_GRID:
            layoutType = LAYOUT_LIST
            navigationItem.leftBarButtonItem?.image = UIImage(named: "ic_view_grid")
            break
        default:
            break
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! MovieDetailViewController
        let index = moviesTableView.indexPathForSelectedRow?.row
        nextVC.movie = movies[index!]
    }
}
