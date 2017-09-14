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
  @IBOutlet weak var backdropImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  
  var movie: [String: Any]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up scroll view
    scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: backdropImage.frame.height + infoView.frame.height)
    
    // Set up details view
    titleLabel.text = movie["original_title"] as? String
    summaryLabel.text = movie["overview"] as? String
    
    if let posterPath = movie["poster_path"] as? String {
      backdropImage.setImageWith(URL(string: Constants.MoviesDB.originalPosterBaseUrl + posterPath)!)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
