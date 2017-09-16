//
//  InfiniteScrollActivityView.swift
//  Flicks
//
//  Created by Wuming Xie on 9/15/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class InfiniteScrollActivityView: UIView {
  
  var activityView = UIActivityIndicatorView()
  static let defaultHeight = CGFloat(60.0)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupActivityIndicator()
  }
  
  override init(frame aRect: CGRect) {
    super.init(frame: aRect)
    setupActivityIndicator()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    activityView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
  }
  
  func setupActivityIndicator() {
    activityView.activityIndicatorViewStyle = .gray
    activityView.hidesWhenStopped = true
    self.addSubview(activityView)
  }
  
  func stopAnimating() {
    activityView.stopAnimating()
    isHidden = true
  }
  
  func startAnimating() {
    isHidden = false
    activityView.startAnimating()
  }
}
