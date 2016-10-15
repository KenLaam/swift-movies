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
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let poster = "https://image.tmdb.org/t/p/original\(movie.value(forKey: "poster_path") as? String ?? "")"
        
        posterImageView.setImageWith(URL(string: poster)!)
        titleLabel.text = (movie.value(forKey: "original_title") as! String)
        overviewLabel.text = (movie.value(forKey: "overview") as! String)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
