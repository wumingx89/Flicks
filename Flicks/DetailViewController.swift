//
//  DetailViewController.swift
//  Flicks
//
//  Created by Wuming Xie on 9/13/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var infoView: UIView!
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  
  var movie: Movie!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up details view
    titleLabel.text = movie.title
    summaryLabel.text = movie.overview
    summaryLabel.sizeToFit()
    
    // Load images
    loadSmallThenLargeImage()
    
    // Set up scroll view
    scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: posterImage.frame.height + infoView.frame.height)
  }
  
  private func loadSmallThenLargeImage() {
    if movie.hasPoster() {
      let smallImageReq = URLRequest(url: URL(string: movie.getSmallSizeURLString()!)!)
      
      posterImage.setImageWith(
        smallImageReq,
        placeholderImage: nil,
        success: { (smallImgReq, smallImgResponse, smallImage) in
          self.posterImage.image = smallImage
          if smallImgResponse != nil {
            self.posterImage.alpha = 0.0
            UIView.animate(withDuration: 0.75, animations: { 
              self.posterImage.alpha = 1.0
            }, completion: { (success) in
              print("Calling load large image - small image was loaded from network")
              self.loadLargeImage(placeholder: smallImage)
            })
          } else {
            print("Calling load large image - small image was loaded from cache")
            self.loadLargeImage(placeholder: smallImage)
          }
      }, failure: { (request, response, error) in
        // Try to get large image
        self.loadLargeImage(placeholder: nil)
      })
    }
  }
  
  private func loadLargeImage(placeholder: UIImage?) {
    let largeImageReq = URLRequest(url: URL(string: movie.getOriginalSizeURLString()!)!)
    print("Attempting to load large image:\n\(largeImageReq.url!.absoluteURL)")
    
    posterImage.setImageWith(
      largeImageReq,
      placeholderImage: placeholder,
      success: { (largeRequest, largeResponse, largeImage) in
        print("Got large image")
        self.posterImage.image = largeImage
        if largeResponse != nil && placeholder == nil {
          self.posterImage.alpha = 0.0
          UIView.animate(withDuration: 0.75, animations: { 
            self.posterImage.alpha = 1.0
          })
        }
    }) { (request, reponse, error) in
      print("Got an error")
      print(error.localizedDescription)
      self.posterImage.image = placeholder
    }
  }
}
