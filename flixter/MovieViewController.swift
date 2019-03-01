//
//  MovieViewController.swift
//  flixter
//
//  Created by Hunter Boleman on 2/21/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // An array of dictionaries
    var movies = [[String:Any]]();
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        // Networking Code
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // Get the array of movies
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Store the movies in a property to use elsewhere
                self.movies = dataDictionary["results"] as! [[String:Any]];
                
                // Reload your table view data
                self.tableView.reloadData();
                
                //print (dataDictionary);
            }
        }
        task.resume()
    }
    
    // Asking for rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }
    // Asking for cols
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell;
        
        let movie = movies[indexPath.row];
        let title = movie["title"] as! String;
        let synopsis = movie["overview"] as! String;
        
        cell.titleLable.text = title;
        cell.synopsisLable.text = synopsis;
        
        let baseURL = "https://image.tmdb.org/t/p/w185";
        let posterPath = movie["poster_path"] as! String;
        let posterUrl = URL(string: baseURL + posterPath);
        
        cell.posterView.af_setImage(withURL: posterUrl!);
        
        return cell;
    }
}
