//
//  Movie.swift
//  TheMovieDB
//
//  Created by Alon Green on 07/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class Video {

    //MARK: - Stored Properties
    private var _title: String
    private var _id: String
    private var _actors: [Character]?
    private var _plot: String?
    private var _director: String?
    private var _runtime: String?
    private var _genre: [String]?
    private var _rating: String?
    private var _voters: String?
    private var _lowResPosterURL: String?
    private var _posterURL: String?{
        didSet{
            if (_posterURL == nil || _posterURL?.isEmpty == true){
                _posterURL = "N/A"
                _lowResPosterURL = "N/A"
            }
            else{
                let poster = _posterURL!
                if _posterURL?.containsString(Constants.TMDB_LARGE_IMAGE_API) == false{
                    _posterURL = Constants.TMDB_LARGE_IMAGE_API + poster
                    _lowResPosterURL =  Constants.TMDB_IMAGE_API + poster
                }
            }
        }
    }
    

    private var _releaseDate: String?
    private var _videoType: VideoType
     
  
  
    
    //MARK: - Computed Properties
    
    var title: String {
        get{
            return _title
        }
        set{
            _title = newValue
        }
    }
    
    var id: String {
        get{
            return _id
        }
    }
    
    var releaseDate: String? {
        get{
            return _releaseDate
        }
        set{
            _releaseDate = newValue
        }
    }

   

    
    var runtime: String? {
        get{
            
            return "\(_runtime!) min"
        }
        set{
            
            _runtime = newValue
        }
    }

    var actors: [Character]? {
        get{
            return _actors
        }
        set{
            _actors = newValue
        }
    }
      
    var plot: String? {
        get{
            return _plot
        }
        set{
            _plot = newValue
        }
    }

   
    var director: String? {
        get{
            return _director
        }
        set{
            _director = newValue
        }
    }
    
        
    var genre: [String]? {
        get{
            return _genre
        }
        set{
            _genre = newValue
        }
    }
    
    var rating: String? {
        get{
            return _rating
        }
        set{
            _rating = newValue
        }
    }
    
    
    var voters: String? {
        get{
            return _voters
        }
        set{
            _voters = newValue
        }
    }

   
    
    var posterURL: String? {
        get{
            return _posterURL
        }
        set{
            _posterURL = newValue
        }
    }
    
    var lowResPosterURL: String? {
        get{
            return _lowResPosterURL
        }
    }

    
    var videoType: VideoType {
        get{
            return _videoType
        }
        set{
            _videoType = newValue
        }
    }

    
    //MARK: - Initializor
    init(title: String,id: String)
    {
        self._title = title
        self._id = id
        _videoType = VideoType.Movie
    }
    
    
    var description: String{
        return _title
    }
    
}


enum VideoType{
    case Movie
    case TV
}

