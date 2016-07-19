//
//  Movie.swift
//  TheMovieDB
//
//  Created by Alon Green on 07/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class Movie {

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
    private var _posterURL: String?
    private var _releaseDate: String?
    private var _endDate: String?
    
     
  
  
    
    //MARK: - Computed Properties
    
    var title: String {
        get{
            return _title
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

    var endDate: String? {
        get{
            return _endDate
        }
        set{
            _endDate = newValue
        }
    }

    
    var runtime: String? {
        get{
            return _runtime
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
    

    
    //MARK: - Initializor
    init(title: String,id: String)
    {
        self._title = title
        self._id = id
    }
    
    
    var description: String{
        return _title
    }
    
}
