//
//  IWebAPIDelegate.swift
//  TheMovieDB
//
//  Created by Alon Green on 09/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit


protocol WebAPIDelegate {
    func fetchMovies(searchString: String, pageIndex: Int?,completionHandler: ([Movie]) -> Void)
    
}

enum WebAPI{
    case IMDB
    case TMDB
}

