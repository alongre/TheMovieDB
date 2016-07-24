//
//  Season.swift
//  TheMovieDB
//
//  Created by Alon Green on 24/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit


class Season{
    
    //MARK: Stored Properties
    private var _title:String
    
    
    private var _air_date: String?
    private var _episode_count: Int?
    private var _id:String
    private var _tvId:String

    private var _lowResPosterURL:String?
    private var _season_number: Int?
    
    
    private var _posterURL: String?{
        didSet{
            if (_posterURL == nil || _posterURL?.isEmpty == true){
                _posterURL = "N/A"
                _lowResPosterURL = "N/A"
            }
            else{
                let poster = _posterURL!
                _posterURL = Constants.TMDB_LARGE_IMAGE_API + poster
                _lowResPosterURL =  Constants.TMDB_IMAGE_API + poster
            }
        }
    }

    
    //MARK: Computed Properties
    
    var id: String {
        get{
            return _id
        }
    }
    
    var tvId: String {
        get{
            return _tvId
        }
    }

    var air_date: String? {
        get{
            return _air_date
        }
        set{
            _air_date = newValue
        }
    }

    var episode_count: Int? {
        get{
            return _episode_count
        }
        set{
            _episode_count = newValue
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
    
    var season_number: Int? {
        get{
            return _season_number
        }
        set{
            _season_number = newValue
        }
    }
    
    var lowResPosterURL: String? {
        get{
            return _lowResPosterURL
        }
    }
    
    var description: String{
        return  "\(_title) - season #\(_season_number!)"
    }
    
    //MARK: Init
    
    init(id: String,tvID: String,title: String){
        _id = id
        _tvId = tvID
        _title = title
        
    }
}
