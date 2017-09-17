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
  
  @IBOutlet weak var moviesCollectionView: UICollectionView!
  @IBOutlet weak var moviesTableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var networkErrorLabel: UILabel!
  @IBOutlet weak var changeViewControl: UISegmentedControl!
  
  var endpoint: String!
  
  fileprivate var loadingMoreView: InfiniteScrollActivityView!
  fileprivate var collectionLoadView: InfiniteScrollActivityView!
  fileprivate var movieObjects: [Movie]?
  fileprivate var filteredTable: [Movie]?
  fileprivate var filteredCollection: [Movie]?
  fileprivate var isMoreDataLoading = false
  fileprivate var currentPage = 0
  fileprivate var totalPages = 0
  fileprivate var originalY = CGFloat(0)
  fileprivate var searchTable = false
  fileprivate var searchCollection = false
  
  func infiniteActivityViewSetup(view: UIScrollView) -> InfiniteScrollActivityView {
    let frame = CGRect(
      x: 0,
      y: view.contentSize.height,
      width: view.bounds.size.width,
      height: InfiniteScrollActivityView.defaultHeight
    )
    let loadingView = InfiniteScrollActivityView(frame: frame)
    loadingView.isHidden = true
    loadingView.tintColor = Constants.Theme.defaultTextColor
    view.addSubview(loadingView)
    
    var insets = view.contentInset
    insets.bottom += InfiniteScrollActivityView.defaultHeight
    view.contentInset = insets
    
    return loadingView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // hide error label
    originalY = networkErrorLabel.frame.origin.y
    hideLabel(animated: false)
    
    showTableOrCollectionView(self)
    
    // Set up Infinite Scroll loading indicator
    loadingMoreView = infiniteActivityViewSetup(view: moviesTableView)
    collectionLoadView = infiniteActivityViewSetup(view: moviesCollectionView)
    
    // Set data source and delegate
    moviesTableView.dataSource = self
    moviesTableView.delegate = self
    moviesCollectionView.dataSource = self
    moviesCollectionView.delegate = self
    searchBar.delegate = self
    
    // Fetch movies
    Movie.fetchMovies(
      endpoint: endpoint,
      loading: {
        ACProgressHUD.shared.showHUD()
      },
      success: { (movies, cur, total) in
        self.successCallBack(movies: movies, cur: cur, total: total)
        ACProgressHUD.shared.hideHUD()
    }) { (error) in
      print(error.debugDescription)
      ACProgressHUD.shared.hideHUD()
      self.showLabel(animated: true)
    }
    
    // Set up refresh control
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.white
    refreshControl.addTarget(self, action: #selector(refreshMovies(_:)), for: .valueChanged)
    moviesTableView.insertSubview(refreshControl, at: 0)
    moviesCollectionView.insertSubview(refreshControl, at: 0)
  }
  
  @IBAction func showTableOrCollectionView(_ sender: Any) {
    searchBar.text = nil
    view.endEditing(true)
    switch changeViewControl.selectedSegmentIndex {
    case 0:
      moviesCollectionView.isHidden = true
      moviesTableView.isHidden = false
      searchTable = false
    default:
      moviesCollectionView.isHidden = false
      moviesTableView.isHidden = true
      searchCollection = false
    }
  }
  
  func refreshMovies(_ refreshControl: UIRefreshControl) {
    hideLabel(animated: true)
    Movie.fetchMovies(
      endpoint: endpoint,
      loading: nil,
      success: { (movies, cur, total) in
        self.successCallBack(movies: movies, cur: cur, total: total)
        refreshControl.endRefreshing()
    }) { (error) in
      print(error.debugDescription)
      refreshControl.endRefreshing()
      self.showLabel(animated: true)
    }
  }
  
  private func successCallBack(movies: [Movie], cur: Int, total: Int) {
    self.movieObjects = movies
    self.currentPage = cur
    self.totalPages = total
    self.moviesTableView.reloadData()
    self.moviesCollectionView.reloadData()
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let movieObjects = movieObjects, movieObjects.count > 0 {
      let indexPath: IndexPath?
      
      if moviesTableView.isHidden {
        indexPath = moviesCollectionView.indexPath(for: sender as! UICollectionViewCell)
      } else {
        indexPath = moviesTableView.indexPath(for: sender as! UITableViewCell)
      }
      
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.movie = movieObjects[indexPath!.row]
    }
  }
  
  // MARK: Error label animation
  fileprivate func hideLabel() {
    networkErrorLabel.frame.origin.y -= networkErrorLabel.frame.height
  }
  
  fileprivate func showLabel() {
    networkErrorLabel.frame.origin.y = originalY
  }
  
  fileprivate func hideLabel(animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.5, animations: { 
        self.hideLabel()
      })
    } else {
      hideLabel()
    }
  }
  
  fileprivate func showLabel(animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.5, animations: { 
        self.showLabel()
      })
    } else {
      showLabel()
    }
  }
}

// MARK: Table view extensions
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let movies = searchTable ? filteredTable : movieObjects
    return movies == nil ? 0 : movies!.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    let movies = searchTable ? filteredTable : movieObjects
    if let movies = movies {
      let movie = movies[indexPath.row]
      cell.setCell(with: movie)
    }
    
    return cell
  }
}

// MARK: Collection view extensions
extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let movies = searchCollection ? filteredCollection : movieObjects
    return movies == nil ? 0 : movies!.count;
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
    
    let movies = searchCollection ? filteredCollection : movieObjects
    if let movies = movies {
      cell.setCell(with: movies[indexPath.row])
    }
    return cell
  }
}

// MARK: Search bar extension
extension MoviesViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let tempMovies = movieObjects?.filter({ (movie) -> Bool in
      if let title = movie.title {
        if let range = title.range(of: searchText, options: String.CompareOptions.caseInsensitive) {
          print(title)
          print(range.description)
          return !range.isEmpty
        }
      }
      return false
    })
    
    print("search: \(searchText), found: \(tempMovies?.count ?? 0)")
    print(tempMovies!)
    
    if moviesTableView.isHidden {
      filteredCollection = tempMovies
      searchCollection = tempMovies != nil && tempMovies!.count > 0
      moviesCollectionView.reloadData()
    } else {
      filteredTable = tempMovies
      searchTable = tempMovies != nil && tempMovies!.count > 0
      moviesTableView.reloadData()
    }
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    
    if moviesTableView.isHidden {
      print("collection begin")
      searchCollection = true
    } else {
      print("begin")
      searchTable = true
    }
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if moviesTableView.isHidden {
      print("collection end")
      //            searchCollectionActive = false
    } else {
      print("end")
      searchTable = false
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    if moviesTableView.isHidden {
      print("collection cancel")
      searchCollection = false
    } else {
      print("cancel")
      searchTable = false
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if moviesTableView.isHidden {
      print("collection search")
      searchCollection = false
    } else {
      print("search")
      searchTable = false
    }
  }
}

// MARK: Scroll view extension
extension MoviesViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (!isMoreDataLoading) {
      let view = moviesTableView.isHidden ? moviesCollectionView : moviesTableView
      let scrollViewContentHeight = view.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - view.bounds.height
      
      if (scrollView.contentOffset.y > scrollOffsetThreshold && view.isDragging && currentPage < totalPages) {
        isMoreDataLoading = true
        currentPage += 1
        
        // Update position of loadingMoreView, and start loading indicator
        let loader = moviesTableView.isHidden ? collectionLoadView : loadingMoreView
        updateInfiniteScrollView(loader: loader!, view: view)
        
        Movie.fetchMovies(
          endpoint: endpoint,
          page: currentPage,
          loading: nil,
          success: { (movies, cur, total) in
            self.movieObjects?.append(contentsOf: movies)
            self.isMoreDataLoading = false
            self.moviesTableView.reloadData()
            self.moviesCollectionView.reloadData()
            loader!.stopAnimating()
        }) { (error) in
          print(error.debugDescription)
          self.loadingMoreView.stopAnimating()
          self.showLabel(animated: true)
        }
      }
    }
  }
  
  func updateInfiniteScrollView(loader: InfiniteScrollActivityView, view: UIScrollView) {
    loader.frame = CGRect(
      x: 0,
      y: view.contentSize.height,
      width: view.bounds.size.width,
      height: InfiniteScrollActivityView.defaultHeight
    )
    hideLabel(animated: true)
    loader.startAnimating()
  }
}

