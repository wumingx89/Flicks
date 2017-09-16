//
//  ViewController.swift
//  Flicks
//
//  Created by Wuming Xie on 9/12/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import AFNetworking
import ACProgressHUD_Swift

class MoviesViewController: UIViewController {
  
  @IBOutlet weak var moviesTableView: UITableView!
  var endpoint: String!
  
  fileprivate var movieObjects: [Movie]?
  fileprivate var movies: [[String: Any]]?
  fileprivate var isMoreDataLoading = false
  fileprivate var currentPage = 0
  fileprivate var totalPages = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set data source and delegate
    moviesTableView.dataSource = self
    moviesTableView.delegate = self
    
    // Fetch movies
    Movie.fetchMovies(
      endpoint: endpoint,
      loading: {
        ACProgressHUD.shared.showHUD()
      },
      success: { (movies, cur, total) in
        self.movieObjects = movies
        self.currentPage = cur
        self.totalPages = total
        self.moviesTableView.reloadData()
        ACProgressHUD.shared.hideHUD()
    }) { (error) in
      print(error.debugDescription)
    }
    
    // Set up refresh control
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshMovies(_:)), for: .valueChanged)
    moviesTableView.insertSubview(refreshControl, at: 0)
  }
  
  func refreshMovies(_ refreshControl: UIRefreshControl) {
    Movie.fetchMovies(
      endpoint: endpoint,
      loading: nil,
      success: { (movies, cur, total) in
        self.movieObjects = movies
        self.currentPage = cur
        self.totalPages = total
        self.moviesTableView.reloadData()
        refreshControl.endRefreshing()
    }) { (error) in
      print(error.debugDescription)
    }
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let movieObjects = movieObjects, movieObjects.count > 0 {
      let cell = sender as! UITableViewCell
      let indexPath = moviesTableView.indexPath(for: cell)
      let movie = movieObjects[indexPath!.row]
      
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.movie = movie
    }
  }
}

extension MoviesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieObjects == nil ? 0 : movieObjects!.count;
  }
}

extension MoviesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    if let movies = movieObjects {
      let movie = movies[indexPath.row]
      cell.titleLabel.text = movie.title
      cell.overviewLabel.text = movie.overview
      
      if let posterPath = movie.posterPath {
        let imageUrl = URL(string: Constants.MoviesDB.smallPosterBaseUrl + posterPath)
        cell.posterView.setImageWith(imageUrl!)
      }
    }
    
    return cell
  }
}

extension MoviesViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      let scrollViewContentHeight = moviesTableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - moviesTableView.bounds.height
      
      if (scrollView.contentOffset.y > scrollOffsetThreshold && moviesTableView.isDragging && currentPage < totalPages) {
        isMoreDataLoading = true
        currentPage += 1
        
        Movie.fetchMovies(
          endpoint: endpoint,
          page: currentPage,
          loading: nil,
          success: { (movies, cur, total) in
            self.movieObjects?.append(contentsOf: movies)
            self.isMoreDataLoading = false
            self.moviesTableView.reloadData()
        }) { (error) in
          print(error.debugDescription)
        }
      }
    }
  }
}

