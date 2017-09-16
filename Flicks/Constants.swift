//
//  Constants.swift
//  Flicks
//
//  Created by Wuming Xie on 9/13/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//
import UIKit

struct Constants {
  
  struct MoviesDB {
    private static let baseURL = "https://api.themoviedb.org/3/movie"
    private static let nowPlaying = "/now_playing"
    private static let topRated = "/top_rated"
    
    static let apiKey = "80e16e10e06289059b790b403e1b409f"
    static let smallPosterBaseUrl = "http://image.tmdb.org/t/p/w92"
    static let originalPosterBaseUrl = "http://image.tmdb.org/t/p/original"
    static let nowPlayingURL = baseURL + nowPlaying
    static let topRatedURL = baseURL + topRated
  }
  
  struct Theme {
    static let barColor = UIColor.black
    static let cellColor = UIColor(red: 0.00, green: 0.16, blue: 0.29, alpha: 1.0)
    static let defaultTextColor = UIColor.white
  }
}
