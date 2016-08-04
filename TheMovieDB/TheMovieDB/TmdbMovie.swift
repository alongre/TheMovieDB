//
//  TmdbMovie.swift
//  TheMovieDB
//
//  Created by Alon Green on 18/06/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit


class TmdbMovie: Video{
    
    //MARK: Stored Properties
    private var _imdbID: String
    private var _releaseDate: String?
    private var _runtime: String?
    
    
    
    
    //MARK: Computed Properties
    override var runtime: String? {
        get{
            return "\(_runtime!) min"
        }
        set{
            _runtime = newValue
        }
    }
    
    var imdbID: String {
        get{
            return _imdbID
        }
    }
    
    
    //MARK: Initializer
    init(title: String,id: String,imdbID: String ){
        _imdbID = imdbID
        super.init(title: title, id: id)
    }
        
}
