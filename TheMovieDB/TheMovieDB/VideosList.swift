//
//  VideosList.swift
//  TheMovieDB
//
//  Created by Alon Green on 03/08/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class VideosList{
    
    var videos: [Video]    
    var totalPages: Int
    var totalResults: Int
    
    init(videos: [Video], totalPages: Int, totalResults: Int){
        self.videos = videos
        self.totalPages = totalPages
        self.totalResults = totalResults
    
    }
    func add(newVideo: Video) -> Bool
    {
        if (videos.contains(newVideo) == false){
            videos.append(newVideo)
            return true
        }
        return false
    }
    
    func add(newVideos: [Video]) -> Bool{
        if self.videos.count < totalResults {
            self.videos.appendContentsOf(newVideos)
            return true
        }
        return false
    }
    
    func clear(){
        self.videos.removeAll()
    }
    func count() -> Int {
        return self.videos.count
    }
    
    func getMovie(index: Int) -> Video?
    {
        if index < videos.count {
            return videos[index]
        }
        return nil
        
    }
    
    func sortByDate() {
        if videos.count > 0 {
            self.videos.sortInPlace({ $0.releaseDate > $1.releaseDate })
        }
    }
    
}
