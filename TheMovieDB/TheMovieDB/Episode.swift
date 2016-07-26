//
//  Episode.swift
//  TheMovieDB
//
//  Created by Alon Green on 24/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit


class Episode:  Video{
    
    //MARK: Stored Properties
   
    private var _episode_number: Int?
    private var _season_number: Int?
    
       
    
    
    
    //MARK: Computed Properties
    
    
    var season_number: Int? {
        get{
            return _season_number
        }
        set{
            _season_number = newValue
        }
    }
    
    var episode_number: Int? {
        get{
            return _episode_number
        }
        set{
            _episode_number = newValue
        }
    }
    
    
    
    
    override var description: String{
        return  "Episode #\(episode_number!) - \(title)"
    }
    
    //MARK: Init
    override init(title: String, id: String) {
        super.init(title: title, id: id)
        videoType = VideoType.Episode
    }
//    convenience override init(title: String, id: String) {
//        self.init(title: title,id: id)
//        videoType = VideoType.Episode
//    }
}
