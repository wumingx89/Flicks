//
//  ViewController.swift
//  Flicks
//
//  Created by Wuming Xie on 9/12/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController {
  
  @IBOutlet weak var moviesTableView: UITableView!
  var endpoint: URL!
  
  fileprivate var movies: [[String: Any]]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    moviesTableView.dataSource = self
    moviesTableView.delegate = self
    
    MoviesViewController.fetchMovies(endpoint: endpoint, successCallBack: { (data) in
      self.movies = data["results"] as? [[String: Any]]
      self.moviesTableView.reloadData()
    }) { (error) in
      print(error.debugDescription)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UITableViewCell
    let indexPath = moviesTableView.indexPath(for: cell)
    let movie = movies![indexPath!.row]
    
    let detailViewController = segue.destination as! DetailViewController
    detailViewController.movie = movie
  }
  
  class func fetchMovies(endpoint: URL, successCallBack: @escaping (NSDictionary) -> (), errorCallBack: ((Error?) -> ())?) {
    let request = URLRequest(url: endpoint, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      if let error = error {
        errorCallBack?(error)
      } else if let data = data,
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
        print(dataDictionary)
        successCallBack(dataDictionary)
      }
    }
    task.resume()
  }
}

extension MoviesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies == nil ? 0 : movies!.count;
  }
}

extension MoviesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    if movies != nil {
      let movie = movies![indexPath.row]
      cell.titleLabel.text = movie["title"] as? String
      cell.overviewLabel.text = movie["overview"] as? String
      
      let posterPath = movie["poster_path"] as! String
      let imageUrl = URL(string: Constants.MoviesDB.smallPosterBaseUrl + posterPath)
      
      cell.posterView.setImageWith(imageUrl!)
    }
    
    return cell
  }
}

