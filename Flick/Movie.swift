//
//  Movie.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


struct Movie {
    
    let title: String
    let posterPath: String
    let overview: String
    let releaseDate: String
    var coverPath: String?
}

extension Movie {
    
    struct Key {
        static let titleKey = "title"
        static let posterPathKey = "poster_path"
        static let overviewKey = "overview"
        static let releaseDateKey = "release_date"
        static let coverPathKey = "backdrop_path"
        static let votesKey = "vote_count"
    }
    
    init?(json: [String: AnyObject]) {
        
        guard let title = json[Key.titleKey] as? String,
            let posterPath = json[Key.posterPathKey] as? String,
            let overview = json[Key.overviewKey] as? String,
            let releaseDate = json[Key.releaseDateKey] as? String
            else {
                return nil
        }
        self.title = title
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.coverPath = json[Key.coverPathKey] as? String
    }
}


struct MovieViewModel {
    
    let title: String
    let posterPathBig: String
    let posterPathSmall: String
    let overview: String
    let releaseDate: String
    var coverPath: String?
    
    init(model: Movie) {
        
        self.title = model.title.uppercased()
        self.posterPathBig = "https://image.tmdb.org/t/p/original" + model.posterPath
        self.posterPathSmall = "https://image.tmdb.org/t/p/w342" + model.posterPath
        self.overview = model.overview
        self.releaseDate = "Release date:" + " " + model.releaseDate
        if let coverPath = model.coverPath {
            self.coverPath = "https://image.tmdb.org/t/p/w342" + coverPath
        }
    }
}


