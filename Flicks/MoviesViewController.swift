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
  fileprivate var isMoreDataLoading = false
  fileprivate var currentPage: Int!
  fileprivate var totalPages: Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set data source and delegate
    moviesTableView.dataSource = self
    moviesTableView.delegate = self
    
    // Fetch movies
    fetchMovies(endpoint: endpoint, successCallBack: { (data) in
      self.movies = data["results"] as? [[String: Any]]
      self.moviesTableView.reloadData()
      self.currentPage = data["page"] as? Int ?? 0
      self.totalPages = data["total_pages"] as? Int ?? 0
    }) { (error) in
      print(error.debugDescription)
    }
    
    // Set up refresh control
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshMovies(_:)), for: .valueChanged)
    moviesTableView.insertSubview(refreshControl, at: 0)
  }
  
  func refreshMovies(_ refreshControl: UIRefreshControl) {
    fetchMovies(endpoint: endpoint, successCallBack: { (data) in
      self.movies = data["results"] as? [[String: Any]]
      self.moviesTableView.reloadData()
      refreshControl.endRefreshing()
    }) { (error) in
      print(error.debugDescription)
    }
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UITableViewCell
    let indexPath = moviesTableView.indexPath(for: cell)
    let movie = movies![indexPath!.row]
    
    let detailViewController = segue.destination as! DetailViewController
    detailViewController.movie = movie
  }
  
  func fetchMovies(endpoint: URL, successCallBack: @escaping (NSDictionary) -> (), errorCallBack: ((Error?) -> ())?) {
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

extension MoviesViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      let scrollViewContentHeight = moviesTableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - moviesTableView.bounds.height
      
      if (scrollView.contentOffset.y > scrollOffsetThreshold && moviesTableView.isDragging) {
        isMoreDataLoading = true
        
        fetchMovies(endpoint: endpoint, successCallBack: <#T##(NSDictionary) -> ()#>, errorCallBack: <#T##((Error?) -> ())?##((Error?) -> ())?##(Error?) -> ()#>)
      }
    }
  }
}

