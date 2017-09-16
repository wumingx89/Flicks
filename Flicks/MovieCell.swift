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
  @IBOutlet weak var overviewLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Disable selection styled
    self.selectionStyle = .none
    
    // Customize cell appearance
//    backgroundColor = Constants.Theme.cellColor
//    titleLabel.textColor = Constants.Theme.defaultTextColor
//    overviewLabel.textColor = Constants.Theme.defaultTextColor
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setCell(with movie: Movie) {
    self.titleLabel.text = movie.title
    self.overviewLabel.text = movie.overview
    self.posterView.image = nil
    
    if let posterPath = movie.getSmallSizeURLString() {
      let originalPosterRequest = URLRequest(
        url: URL(string: posterPath)!,
        cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
        timeoutInterval: 10)
      self.posterView.setImageWith(
        originalPosterRequest,
        placeholderImage: nil,
        success: { (request, response, image) in
          if response != nil  {
            // Image was not cached
            self.posterView.alpha = 0.0
            self.posterView.image = image
            UIView.animate(withDuration: 0.75) {
              self.posterView.alpha = 1.0
            }
          } else {
            // Image was cached, just load the image
            self.posterView.image = image
          }
      }, failure: { (request, response, error) in
        
      })
    } else {
      self.posterView.image = nil
    }
  }
  
  fileprivate func fadeInImage() {
    UIView.animate(withDuration: 0.75) { 
      self.posterView.alpha = 1.0
    }
  }
}
