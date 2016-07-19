//
//  TmdbMovie.swift
//  TheMovieDB
//
//  Created by Alon Green on 18/06/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit


class TmdbMovie: Movie{
    
    //MARK: Stored Properties
    private var _imdbID: String
    private var _releaseDate: String?
    private var _runtime: String?
    
    
    
    
    //MARK: Computed Properties
    override var releaseDate: String?{
        get{
            return _releaseDate
        }
        set{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.lenient = true
            let date = dateFormatter.dateFromString(newValue!)
            
            if let date = date {
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                print(components.year)
                _releaseDate = String(components.year)
                
            }
            
        }
    }
    
    
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
