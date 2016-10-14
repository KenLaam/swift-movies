//
//  HomeViewController.swift
//  Movies
//
//  Created by Ken Lâm on 10/14/16.
//  Copyright © 2016 Ken Lam. All rights reserved.
//

import UIKit
import AFNetworking

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    
    var movies = [NSDictionary]()
    var refreshControl = UIRefreshControl()
    var isLoading = false
    var page = 1
    var totalPages = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        fetchData(page: page)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData(page: Int) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&page=\(page)")
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
                    if let data = dataOrNil {
                        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.isLoading = false
                            if let moviesData = responseDictionary["results"] as? [NSDictionary] {
                                if self.movies.count == 0 {
                                    self.movies = moviesData
                                    self.totalPages = responseDictionary.value(forKey: "total_pages") as! Int
                                } else {
                                    for movie in moviesData {
                                        self.movies.append(movie)
                                    }
                                }
                                self.moviesTableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                        }
                    }
            })
            task.resume()
        }
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieViewCell
        let movie = movies[indexPath.row]
        let poster = "https://image.tmdb.org/t/p/w342\(movie.value(forKey: "poster_path") as? String ?? "")"
        cell.titleLabel.text = (movie.value(forKey: "title") as! String)
        cell.posterImageView.setImageWith(URL(string: poster)!)
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
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
