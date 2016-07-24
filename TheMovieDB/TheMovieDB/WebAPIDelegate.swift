//
//  IWebAPIDelegate.swift
//  TheMovieDB
//
//  Created by Alon Green on 09/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit


protocol WebAPIDelegate {
    func fetchMovies(searchString: String, pageIndex: Int?,completionHandler: ([Video]) -> Void)
    func fetchMoviesWithURL(url: String,pageIndex: Int?,completionHandler: ([Video]) -> Void)
    func fetchTVShows(searchString:String, pageIndex:Int?, completionHandler: ([Video]) -> Void)
    func fetchDetailedVideoInfo(id:String,completionHandler: (Video) -> Void)
    func fetchCastList(id: String,videoType: VideoType, completionHandler: ([Character]) -> Void)
    func fetchPersonDetail(id: String, completionHandler: (Character) -> Void)
    func fetchPersonMovies(id: String, completionHandler: ([Video]) -> Void)
    func fetchDetailedTVInfo(id:String,completionHandler: (Video) -> Void)
    func fetchTVEpisodes(id:String, season:Int, completionHandler: ([Episode]) -> Void)


    
    
}


