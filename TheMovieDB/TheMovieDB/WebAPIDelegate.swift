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
    func fetchMoviesWithURL(url: String,pageIndex: Int?,completionHandler: ([Movie]) -> Void)
    func fetchTVShows(searchString:String, pageIndex:Int?, completionHandler: ([Movie]) -> Void)
    func fetchDetailedVideoInfo(id:String,completionHandler: (Movie) -> Void)
    func fetchCastList(id: String, completionHandler: ([Character]) -> Void)
    func fetchPersonDetail(id: String, completionHandler: (Character) -> Void)
    func fetchPersonMovies(id: String, completionHandler: ([Movie]) -> Void)
    func fetchDetailedTVInfo(id:String,completionHandler: (Movie) -> Void)

    
    
}


