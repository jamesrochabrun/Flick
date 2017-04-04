//
//  MovieViewModel.swift
//  Flick
//
//  Created by James Rochabrun on 4/4/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

struct MovieViewModel {
    
    let title: String
    let posterPathBig: String
    let posterPathSmall: String
    let overview: String
    let releaseDate: String
    var coverPath: String?
    var isGrid: Bool = false
    
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


