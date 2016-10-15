//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Ken Lâm on 10/14/16.
//  Copyright © 2016 Ken Lam. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = (movie.value(forKey: "original_title") as! String)
        overviewTextView.text = (movie.value(forKey: "overview") as! String)
        posterImageView.alpha = 0.0
        let poster = "https://image.tmdb.org/t/p/w342\(movie.value(forKey: "poster_path") as? String ?? "")"
        let urlRequest = URLRequest(
            url: URL(string: poster)!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 5)
        
        posterImageView.setImageWith( urlRequest, placeholderImage: nil, success: { (request, response, image) in
            self.posterImageView.image = image
            UIView.animate(withDuration: 1, animations: {
                self.posterImageView.alpha = 1.0
            })
            
        }) { (request, response, error) in
            self.showError(error: error.localizedDescription)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Error networking", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
