//
//  MovieService.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

import UIKit

struct MovieService {
    
    static let sharedInstance = MovieService()
    private init(){}

    static let APIKey: String = "34a92f7d77a168fdcd9a46ee1863edf1"
    var nowPlayingendpoint: String {
        return "https://api.themoviedb.org/3/movie/now_playing?api_key=\(MovieService.APIKey)"
    }
    
    var topRatedEndpoint: String {
        return "https://api.themoviedb.org/3/movie/top_rated?api_key=\(MovieService.APIKey)"
    }
    
    let downloader = JSONDownloader()
    
    
    typealias MoviesNowPlayingCompletionHandler = (Result<[Movie?]>) -> ()
    func getNowPlayingMovies(completion: @escaping MoviesNowPlayingCompletionHandler) {
        
        guard let url = URL(string: self.nowPlayingendpoint) else {
            completion(.Error(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .Error(let error):
                    completion(.Error(error))
                    return
                case .Success(let json):
                    guard let movieJSONFeedArray = json["results"] as? [[String: AnyObject]] else {
                        completion(.Error(.jsonParsingFailure))
                        return
                    }
                    let movieArray = movieJSONFeedArray.map{Movie(json: $0)}
                    completion(.Success(movieArray))
                }
            }
        }
        task.resume()
    }
    
    typealias TopRatedMoviesCompletionHandler = (Result<[Movie?]>) -> ()
    func getTopRatedMovies(completion: @escaping TopRatedMoviesCompletionHandler) {
        
        guard let url = URL(string: self.topRatedEndpoint) else {
            completion(.Error(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .Error(let error):
                    completion(.Error(error))
                    return
                case .Success(let json):
                    guard let movieJSONFeedArray = json["results"] as? [[String: AnyObject]] else {
                        completion(.Error(.jsonParsingFailure))
                        return
                    }
                    let movieArray = movieJSONFeedArray.map{Movie(json: $0)}
                    completion(.Success(movieArray))
                }
            }
        }
        task.resume()
    }
}


















