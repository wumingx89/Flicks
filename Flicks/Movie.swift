//
//  Movie.swift
//  Flicks
//
//  Created by Wuming Xie on 9/15/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import AFNetworking

class Movie {
  private static let idKey = "id"
  private static let titleKey = "title"
  private static let posterKey = "poster_path"
  private static let overviewKey = "overview"
  private static let voteAvgKey = "vote_average"
  private static let releaseKey = "release_date"
  
  private static let sessionManager = { () -> AFHTTPSessionManager in 
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.timeoutInterval = TimeInterval(10)
    return manager
  }()
  
  private(set) var id: Int?
  private(set) var title: String?
  private(set) var overview: String?
  private(set) var posterPath: String?
  private(set) var voteAvg: Double!
  private(set) var releaseDate: String?
  
  init(from json: [String: Any]) {
    id = json[Movie.idKey] as? Int
    title = json[Movie.titleKey] as? String
    overview = json[Movie.overviewKey] as? String
    posterPath = json[Movie.posterKey] as? String
    voteAvg = json[Movie.voteAvgKey] as? Double ?? 0.0
    releaseDate = json[Movie.releaseKey] as? String
  }
  
  func hasPoster() -> Bool {
    return posterPath != nil
  }
  
  func getSmallSizeURLString() -> String? {
    if hasPoster() {
      return Constants.MoviesDB.smallPosterBaseUrl + posterPath!
    }
    return nil
  }
  
  func getOriginalSizeURLString() -> String? {
    if hasPoster() {
      return Constants.MoviesDB.originalPosterBaseUrl + posterPath!
    }
    return nil
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
