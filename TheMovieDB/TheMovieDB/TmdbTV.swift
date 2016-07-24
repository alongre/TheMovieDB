//
//  TmdbTV.swift
//  TheMovieDB
//
//  Created by Alon Green on 18/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class TmdbTV: Video{
    
    
    //MARK: Stored Properties

    private var _releaseDate: String?
    private var _endDate: String?
    private var _numberOfSeason:Int?
    private var _numberOfEpisodes:Int?
    private var _imdbID: String
    var seasons: [Season]?
  
    
  
    
    
    
    //MARK: Computed Properties
    override var releaseDate: String?{
        get{
            if _endDate != nil{
                
                return "(\(_releaseDate!) - \(_endDate!))"
            }
            return _releaseDate!
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
    
    
    var endDate: String? {
        get{
            return _endDate
        }
        set{
            if newValue != nil{
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.lenient = true
                let date = dateFormatter.dateFromString(newValue!)
                
                if let date = date {
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                    print(components.year)
                    _endDate = String(components.year)
                    
                }
            }
            else{
                _endDate = newValue
            }
            
        }

    }
    
    var numberOfSeason: Int? {
        get{
            return _numberOfSeason
        }
        set{
            _numberOfSeason = newValue
        }
    }

    var numberOfEpisodes: Int? {
        get{
            return _numberOfEpisodes
        }
        set{
            _numberOfEpisodes = newValue
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
        videoType = VideoType.TV
        seasons = [Season]()
    }
    
    override var description: String{
        return "\(_numberOfSeason!) seasons(\(_numberOfEpisodes!) episodes)"
    }

    
}