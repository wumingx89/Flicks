//
//  MovieCollectionCell.swift
//  Flicks
//
//  Created by Wuming Xie on 9/17/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  func setCell(with movie: Movie) {
    titleLabel.text = String(movie.voteAvg)
    
    MovieCell.getImage(forView: posterView, movie: movie)
  }
}
