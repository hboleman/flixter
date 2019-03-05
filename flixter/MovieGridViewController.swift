//
//  MovieGridViewController.swift
//  flixter
//
//  Created by Hunter Boleman on 2/28/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // An array of dictionaries
    var movies = [[String:Any]]();
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        // Advanced Layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout;
        
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        
        // make size of screen width, divided by blank
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3;
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        // Do any additional setup after loading the view.
        
        // Networking Code
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                
                self.collectionView.reloadData();
                //print(self.movies);
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell;
        
        let movie = movies[indexPath.item];
        
        // URL Logic
        let baseURL = "https://image.tmdb.org/t/p/w185";
        // Set poster image
        let posterPath = movie["poster_path"] as! String;
        let posterUrl = URL(string: baseURL + posterPath);
        cell.posterView.af_setImage(withURL: posterUrl!);
        
        return cell;
    }
    
    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell number: \(indexPath.row)")
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("loading up details screen...");
        
        // Find selected movie
        let cell = sender as! UICollectionViewCell;
        let indexPath = collectionView.indexPath(for: cell)!;
        let movie = movies[indexPath.row];
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController;
        detailsViewController.movie = movie;
        
        // Deselect row before segue
        collectionView.deselectItem(at: indexPath, animated: true);
        
    }
 
    

}
