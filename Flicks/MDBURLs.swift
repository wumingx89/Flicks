//
//  MDBURLs.swift
//  Flicks
//
//  Created by wuming on 9/14/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation

class MDBURLs {
  private static let apiKey = "80e16e10e06289059b790b403e1b409f"
  private static let baseURLString = "https://api.themoviedb.org/3/movie"
  private static let nowPlaying = "/now_playing"
  private static let topRated = "/top_rated"
  
  static let nowPlayingURL = getURL(nowPlaying)
  static let topRatedURL = getURL(topRated)
  
  private class func getURL(_ endpoint: String) -> URL {
    return URL(string: "\(baseURLString)\(endpoint)?api_key=\(apiKey)")!
  }
}
