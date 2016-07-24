//
//  TMDB.swift
//  TheMovieDB
//
//  Created by Alon Green on 09/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class TMDB: WebAPIDelegate{
    
    
    //MARK: - WebAPIDelegate methods
    
    func fetchMovies(movieName: String, pageIndex: Int?,completionHandler: ([Video]) -> Void){
        var index = 1
        if let pageIndex = pageIndex {
            index = pageIndex
        }
        let url = NSURL(string: Constants.TMDB_SEARCH_MOVIE_API)
        
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY,
                                                "query":movieName,
                                                "page": String(index)]
        Alamofire.request(
            .GET,
            url!,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching movies: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToMovies(response.data))
                
        }

    }
    
    
    func fetchDetailedVideoInfo(id:String,completionHandler: (Video) -> Void)
    {
        
        
        
        let url = NSURL(string: Constants.TMDB_MOVIE_WITH_ID_API + "/\(id)")
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY]
                                                
        Alamofire.request(
            .GET,
            url!,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching movies: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToFullInfoMovie(response.data)!)
                
        }
       

    }
    func fetchDetailedTVInfo(id:String,completionHandler: (Video) -> Void){
        let url = NSURL(string: Constants.TMDB_TV_WITH_ID_API + "/\(id)")
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY,
                                                "append_to_response":"external_ids"]

        
        Alamofire.request(
            .GET,
            url!,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching movies: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToFullInfoTV(response.data)!)
                
        }

    }

    

    
    func fetchTVEpisodes(id:String, season:Int, completionHandler: ([Episode]) -> Void){
        
        
        
        let url = NSURL(string: Constants.TMDB_TV_WITH_ID_API + "/\(id)" + "/season" + "/\(season)")

        
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY,
                                                "append_to_response":"credits"]
        
        Alamofire.request(
            .GET,
            url!,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching movies: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToEpisodes(response.data))
                
        }
        

        
        
    }
    
    func fetchTVShows(searchString:String, pageIndex:Int?, completionHandler: ([Video]) -> Void){
        
        var index = 1
        if let pageIndex = pageIndex {
            index = pageIndex
        }
        let url = NSURL(string: Constants.TMDB_SEARCH_TV_API)
        
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY,
                                                "query":searchString,
                                                "page": String(index)]
        Alamofire.request(
            .GET,
            url!,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching movies: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToTV(response.data))
                
        }
        
        
        
        
    }
    
    func fetchMoviesWithURL(url: String,pageIndex: Int?,completionHandler: ([Video]) -> Void){
        var index = 1
        if let pageIndex = pageIndex {
            index = pageIndex
        }
        let url = NSURL(string: url)
        
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY,
                                                "page": String(index)]
        Alamofire.request(
            .GET,
            url!,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching movies: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToMovies(response.data))
                
        }
        
    }
    
    
    
    
    func fetchCastList(id: String, videoType: VideoType, completionHandler: ([Character]) -> Void){
        var url: NSURL
        if videoType == VideoType.Movie {
            url = NSURL(string: Constants.TMDB_MOVIE_WITH_ID_API + "/\(id)" + "/credits")!
        }
        else{
             url = NSURL(string: Constants.TMDB_TV_WITH_ID_API + "/\(id)" + "/credits")!
        }
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY]
        
        Alamofire.request(
            .GET,
            url,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching movies: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToCharacterList(response.data))
                
        }
        
        
        
    }
    
    func fetchPersonDetail(id: String, completionHandler: (Character) -> Void){
        let url = NSURL(string: Constants.TMDB_PERSON_DETAILS_API + "/\(id)")
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY]
        
        Alamofire.request(
            .GET,
            url!,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching person info: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToCharacter(response.data)!)
                
        }
        
        
        
    }

    
    func fetchPersonMovies(id: String, completionHandler: ([Video]) -> Void){
        let url = NSURL(string: Constants.TMDB_PERSON_DETAILS_API + "/\(id)" + "/movie_credits")
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY]
        
        Alamofire.request(
            .GET,
            url!,
            parameters: paramDictionary,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching person info: \(response.result.error)")
                    return
                }
                completionHandler(self.dataToMoviesPerActor(response.data))
                
        }
        
        
        
    }


    
    //MARK: - Conversion Methods from NSData to relevant types
    
    
    func dataToCharacter(data:NSData?) -> Character? {
        var actor: Character
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let name = json["name"].stringValue
        let id = json["id"].stringValue
        let birthday = json["birthday"].stringValue
        let deathday = json["deathday"].stringValue
        let birthplace = json["place_of_birth"].stringValue
         let bio = json["biography"].stringValue
        
        actor = Character(name: name)

        
        if (json["profile_path"].null == nil){
            actor.posterURL = Constants.TMDB_LARGE_IMAGE_API + json["profile_path"].stringValue
        }
        else
        {
            actor.posterURL  = "N/A"
        }

        actor.ID = id
        actor.Birthday = birthday
        actor.Birthplace = birthplace
        actor.DeathDay = deathday
        actor.Biography = bio
        return actor
    }

    func dataToMoviesPerActor(data:NSData?) -> [Video] {
        var movies = [Video]()
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let results = json["cast"]
        for (_,subJson):(String, JSON) in results {
            let title = subJson["title"].stringValue
            let id = subJson["id"].stringValue
            let movie = TmdbMovie(title: title, id: id, imdbID: "")
            
            movie.releaseDate = subJson["release_date"].stringValue
            movie.posterURL = subJson["poster_path"].stringValue
            
            
            
            movies.append(movie)
        }
        
        return movies
    }

    
    func dataToMovies(data:NSData?) -> [Video] {
        var movies = [Video]()
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let results = json["results"]
        for (_,subJson):(String, JSON) in results {
            let title = subJson["original_title"].stringValue
            let id = subJson["id"].stringValue
            let movie = TmdbMovie(title: title, id: id, imdbID: "")
            
            movie.releaseDate = subJson["release_date"].stringValue
            movie.posterURL = subJson["poster_path"].stringValue
            movie.rating = subJson["vote_average"].stringValue
            movies.append(movie)
        }
        
        return movies
    }

    func dataToTV(data:NSData?) -> [Video] {
        var movies = [Video]()
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let results = json["results"]
        for (_,subJson):(String, JSON) in results {
            let title = subJson["name"].stringValue
            let id = subJson["id"].stringValue
            let movie = TmdbMovie(title: title, id: id, imdbID: "")
            movie.releaseDate = subJson["first_air_date"].stringValue
            movie.posterURL = subJson["poster_path"].stringValue
            movies.append(movie)
        }
        
        return movies
    }

    
    func dataToFullInfoMovie(data:NSData?) -> TmdbMovie? {
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let id = json["id"].stringValue
        let title = json["original_title"].stringValue
        let imdbID = json["imdb_id"].stringValue
        
        let movie = TmdbMovie(title: title, id: id,imdbID: imdbID)
        movie.posterURL = Constants.TMDB_LARGE_IMAGE_API + json["poster_path"].stringValue
        movie.plot = json["overview"].stringValue
        movie.runtime = json["runtime"].stringValue
        movie.releaseDate = json["release_date"].stringValue
        let genres = json["genres"]
        movie.genre = [String]()

        for gen in genres {
               movie.genre?.append(gen.1["name"].stringValue)
        }
        return movie
        
     
    }

    func dataToFullInfoTV(data:NSData?) -> TmdbTV? {
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let id = json["id"].stringValue
        let title = json["name"].stringValue
        let ids = json["external_ids"]
        let imdbID = ids["imdb_id"].stringValue
        let tv = TmdbTV(title: title, id: id,imdbID: imdbID)
        
          tv.posterURL = json["poster_path"].stringValue
        
        
        
        tv.plot = json["overview"].stringValue
        let runTime = json["episode_run_time"][0]
        tv.runtime =  runTime.stringValue
        tv.releaseDate = json["first_air_date"].stringValue
        tv.endDate = json["last_air_date"].stringValue
        tv.numberOfEpisodes = json["number_of_episodes"].intValue
        tv.numberOfSeason = json["number_of_seasons"].intValue
        

        let genres = json["genres"]
        tv.genre = [String]()
        
        for gen in genres {
            tv.genre?.append(gen.1["name"].stringValue)
        }
        
        
        let seasons = json["seasons"]
        
        for (_,subJson):(String, JSON) in seasons {
            let seasonId = subJson["id"].stringValue
            let air_date = subJson["air_date"].stringValue
            let episode_count = subJson["episode_count"].intValue
            let poster_path = subJson["poster_path"].stringValue
            let season_number = subJson["season_number"].intValue

            let season = Season(id: seasonId, tvID: tv.id, title: tv.title)
            season.air_date = air_date
            season.episode_count = episode_count
            season.season_number = season_number
            season.posterURL = poster_path
            print(season.description)
            tv.seasons?.append(season)
        }
        
        return tv
        
        
    }

    
    func dataToEpisodes(data: NSData?) -> [Episode]{
        
        
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        var episodesList = [Episode]()
        let episodes = json["episodes"]
        for (_,subJson):(String, JSON) in episodes {
            let id = subJson["id"].stringValue
            let airDate = subJson["air_date"].stringValue
            let name = subJson["name"].stringValue
            let episode_number = subJson["episode_number"].intValue
            let plot = subJson["overview"].stringValue
            let posterURL = subJson["still_path"].stringValue
            let season_number = subJson["season_number"].intValue
            
            let episode = Episode(id: id, title: name)
            episode.air_date = airDate
            episode.episode_number = episode_number
            episode.posterURL = posterURL
            episode.season_number = season_number
            episode.plot = plot
            
           // var actorsList = [Character]()
//            if subJson["guest_stars"].exists(){
//
//                let guest_stars = subJson["guest_stars"]
//                for (_,subJson):(String, JSON) in guest_stars {
//                    let actorID = subJson["id"].stringValue
//                    let actorName = subJson["name"].stringValue
//                    let characterName = subJson["character"].stringValue
//                    let actorPoster = subJson["profile_path"].stringValue
//                    
//                    let actor = Character(name: actorName)
//                    actor.JobPosition = Job.ACTOR
//                    actor.CharacterName = characterName
//                    actor.posterURL = actorPoster
//                    actor.ID = actorID
//                    
//                    actorsList.append(actor)
//                    
//                }
//                
//            
//            }
//            
          //  episode.actors = actorsList
            episodesList.append(episode)
            
            
        }
        return episodesList
        

        
        
    }
    
    func dataToCharacterList(data: NSData?) -> [Character]{
        
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        var actorsList = [Character]()
        let results = json["cast"]
        for (_,subJson):(String, JSON) in results {
            if subJson["character"].exists(){
                let id = subJson["id"].stringValue
                let charName = subJson["character"].stringValue
                let name = subJson["name"].stringValue
                let character = Character(name: name)
                character.ID = id
                if (subJson["profile_path"].null == nil){
                    character.posterURL = Constants.TMDB_LARGE_IMAGE_API + subJson["profile_path"].stringValue
                }
                else
                {
                    character.posterURL  = "N/A"
                }
                character.CharacterName = charName
                character.JobPosition = Job.ACTOR
                actorsList.append(character)
            }
            
            print(actorsList)
        }
        return actorsList
        
    }
    
}
