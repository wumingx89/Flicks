//
//  MovieCell.swift
//  Flicks
//
//  Created by Wuming Xie on 9/12/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Disable selection styled
    selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setCell(with movie: Movie) {
    titleLabel.text = movie.title
    overviewLabel.text = movie.overview
    ratingLabel.text = String(movie.voteAvg)
    releaseDateLabel.text = movie.releaseDate
    
    MovieCell.getImage(forView: posterView, movie: movie)
  }
  
  class func getImage(forView posterView: UIImageView, movie: Movie) {
    posterView.image = nil
    
    if let posterPath = movie.getSmallSizeURLString() {
      let originalPosterRequest = URLRequest(
        url: URL(string: posterPath)!,
        cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
        timeoutInterval: 10)
      
      posterView.setImageWith(
        originalPosterRequest,
        placeholderImage: nil,
        success: { (request, response, image) in
          if response != nil  {
            // Image was not cached
            posterView.alpha = 0.0
            posterView.image = image
            UIView.animate(withDuration: 0.75) {
              posterView.alpha = 1.0
            }
          } else {
            // Image was cached, just load the image
            posterView.image = image
          }
      }, failure: { (request, response, error) in
        
      })
    }
  }
}
