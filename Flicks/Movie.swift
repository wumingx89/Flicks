//
//  Movie.swift
//  Flicks
//
//  Created by Wuming Xie on 9/15/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import AFNetworking

class Movie {
  private static let titleKey = "title"
  private static let posterKey = "poster_path"
  private static let overviewKey = "overview"
  private static let sessionManager = { () -> AFHTTPSessionManager in 
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.timeoutInterval = TimeInterval(10)
    return manager
  }()
  
  var title: String?
  var posterPath: String?
  var overview: String?
  
  init(from json: [String: Any]) {
    title = json[Movie.titleKey] as? String
    posterPath = json[Movie.posterKey] as? String
    overview = json[Movie.overviewKey] as? String
  }
  
  class func fetchMovies(endpoint: String,
                         page: Int = 1,
                         loading: (() -> ())?,
                         success: @escaping ([Movie], Int, Int) -> (),
                         error: ((Error?) -> ())?) {
    
    if let loading = loading {
      loading()
    }
    
    sessionManager.get(
      endpoint,
      parameters: ["api_key": Constants.MoviesDB.apiKey, "page": page],
      progress: nil,
      success: { (operation, responseObject) in
        if let json = responseObject as? NSDictionary,
          let results = json["results"] as? [[String: Any]] {
          var movies: [Movie] = []
          for result in results {
            movies.append(Movie(from: result))
          }
          success(movies, json["page"] as? Int ?? 1, json["total_pages"] as? Int ?? 1)
        }
      },
      failure: { (operation, errorObject) in
        if let error = error {
          error(errorObject)
        }
    })
  }
}
