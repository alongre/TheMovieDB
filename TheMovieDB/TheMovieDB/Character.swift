//
//  Character.swift
//  TheMovieDB
//
//  Created by Alon Green on 23/06/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit

class Character{
 
    
    //MARK: - Stored Properties

    private var _name: String
    private var _characterName: String?
    private var _id: String?
    private var _posterURL: String?
    private var _job: Job?
    private var _birthday: String?
    private var _birthPlace: String?
    private var _deathDay: String?
    private var _biography: String?
    
    //MARK: - Constructor
    init(name: String){
        self._name = name
        _job = Job.ACTOR
    }
    
    
     //MARK: - Computed Properties
    
    var Birthday: String? {
        get{
            return _birthday
        }
        set{
            _birthday = newValue
        }
    }
    
    var Biography: String? {
        get{
            return _biography
        }
        set{
            _biography = newValue
        }
    }
    
    var Birthplace: String? {
        get{
            return _birthPlace
        }
        set{
            _birthPlace = newValue
        }
    }
    
    var DeathDay: String? {
        get{
            return _deathDay
        }
        set{
            _deathDay = newValue
        }
    }
    
    var Name: String? {
        get{
            return _name
        }
    }

    var CharacterName: String? {
        get{
            return _characterName
        }
        set{
            _characterName = newValue
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
    var ID: String? {
        get{
            return _id
        }
        set{
            _id = newValue
        }
    }
    
    var JobPosition: Job? {
        get{
            return _job
        }
        set{
            _job = newValue
        }
    }
    
    var description: String{
        return _name
    }
    
   }




enum Job{
    case ACTOR
    case DIRECTOR
}
