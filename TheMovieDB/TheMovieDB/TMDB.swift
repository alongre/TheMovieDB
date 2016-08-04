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
    
    func fetchMovies(movieName: String, pageIndex: Int?,completionHandler: (VideosList) -> Void){
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
    
    
    func fetchDetailedMovieInfo(id:String,completionHandler: (Video) -> Void)
    {
        
        
        
        let url = NSURL(string: Constants.TMDB_MOVIE_WITH_ID_API + "/\(id)")
        let paramDictionary: [String:String] = ["api_key":Constants.TMDB_KEY,
                                                 "append_to_response":"credits,external_ids"]
                                                
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
                                                "append_to_response":"credits,external_ids"]

        
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
    
    func fetchTVEpisode(id:String, season:Int, episode: Int, completionHandler: (Episode) -> Void){
        
        
        
        let url = NSURL(string: Constants.TMDB_TV_WITH_ID_API + "/\(id)" + "/season" + "/\(season)" + "/episode" + "/\(episode)")
        
        
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
                completionHandler(self.dataToEpisode(response.data))
                
        }
        
        
        
        
    }

    
    func fetchTVShows(searchString:String, pageIndex:Int?, completionHandler: (VideosList) -> Void){
        
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
    
    func fetchMoviesWithURL(url: String,pageIndex: Int?,completionHandler: (VideosList) -> Void){
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

    
    func fetchPersonMovies(id: String, completionHandler: (VideosList) -> Void){
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
        actor = Character(name: json["name"].stringValue)
        actor.posterURL = json["profile_path"].stringValue
        actor.ID = json["id"].stringValue
        actor.Birthday = json["birthday"].stringValue
        actor.Birthplace = json["place_of_birth"].stringValue
        actor.DeathDay = json["deathday"].stringValue
        actor.Biography = json["biography"].stringValue

        return actor
    }

    func dataToMoviesPerActor(data:NSData?) -> VideosList {
       
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let totalPages = json["total_pages"].intValue
        let totalResults = json["total_results"].intValue
        let videoList = VideosList(videos: [Video](),totalPages: totalPages, totalResults: totalResults)

        let results = json["cast"]
        for (_,subJson):(String, JSON) in results {
            let title = subJson["title"].stringValue
            let id = subJson["id"].stringValue
            let movie = TmdbMovie(title: title, id: id, imdbID: "")
            
            movie.releaseDate = subJson["release_date"].stringValue
            movie.posterURL = subJson["poster_path"].stringValue
            
            
            
           videoList.add(movie)
        }
        
        return videoList
    }

    
    func dataToMovies(data:NSData?) -> VideosList {
        
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        let totalPages = json["total_pages"].intValue
        let totalResults = json["total_results"].intValue
        let videoList = VideosList(videos: [Video](),totalPages: totalPages, totalResults: totalResults)
        let results = json["results"]
        for (_,subJson):(String, JSON) in results {
            let title = subJson["original_title"].stringValue
            let id = subJson["id"].stringValue
            let video = TmdbMovie(title: title, id: id, imdbID: "")
            
            video.releaseDate = subJson["release_date"].stringValue
            video.posterURL = subJson["poster_path"].stringValue
            video.rating = subJson["vote_average"].stringValue
            videoList.add(video)
        }
        
        return videoList
    }

    func dataToTV(data:NSData?) -> VideosList {
        
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        let totalPages = json["total_pages"].intValue
        let totalResults = json["total_results"].intValue
        let videoList = VideosList(videos: [Video](),totalPages: totalPages, totalResults: totalResults)
        
        let results = json["results"]
        for (_,subJson):(String, JSON) in results {
            let title = subJson["name"].stringValue
            let id = subJson["id"].stringValue
            let movie = TmdbMovie(title: title, id: id, imdbID: "")
            movie.releaseDate = subJson["first_air_date"].stringValue
            movie.posterURL = subJson["poster_path"].stringValue
            videoList.add(movie)
        }
        
        return videoList
    }

    
    func dataToFullInfoMovie(data:NSData?) -> TmdbMovie? {
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)

        let movie = TmdbMovie(title: json["original_title"].stringValue, id: json["id"].stringValue,imdbID: json["imdb_id"].stringValue)
        movie.posterURL = json["poster_path"].stringValue
        movie.plot = json["overview"].stringValue
        movie.runtime = json["runtime"].stringValue
        movie.releaseDate = json["release_date"].stringValue
        movie.actors = getActors(json, root: "credits", subRoot: "cast")
        
        
        let genres = json["genres"]
        movie.genre = [String]()

        for gen in genres {
               movie.genre?.append(gen.1["name"].stringValue)
        }
        return movie
        
     
    }

    
    func getActors(json: JSON,root: String, subRoot: String) -> [Character]{
        
        
        var actorsList = [Character]()
        let actors = json[root]
        let cast = actors[subRoot]
        for (_,subJson):(String, JSON) in cast {
                let character = Character(name: subJson["name"].stringValue)
                character.ID = subJson["id"].stringValue
                character.posterURL = subJson["profile_path"].stringValue
                character.CharacterName = subJson["character"].stringValue
                character.JobPosition = Job.ACTOR
                actorsList.append(character)
            
            
         //   print(actorsList)
        }
        return actorsList
        
        
    }
   
    func getActors(json: JSON,root: String) -> [Character]{
        
        
        var actorsList = [Character]()
        let actors = json[root]
        for (_,subJson):(String, JSON) in actors {
            
                let character = Character(name: subJson["name"].stringValue)
                character.ID = subJson["id"].stringValue
                character.posterURL = subJson["profile_path"].stringValue
                character.CharacterName = subJson["character"].stringValue
                character.JobPosition = Job.ACTOR
                actorsList.append(character)
            
            
        
        }
        return actorsList
        
        
    }

    
    func dataToFullInfoTV(data:NSData?) -> TmdbTV? {
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let ids = json["external_ids"]
        let imdbID = ids["imdb_id"].stringValue
        let tv = TmdbTV(title: json["name"].stringValue, id: json["id"].stringValue,imdbID: imdbID)
        tv.posterURL = json["poster_path"].stringValue
        tv.plot = json["overview"].stringValue
        let runTime = json["episode_run_time"][0]
        tv.runtime =  runTime.stringValue
        tv.releaseDate = json["first_air_date"].stringValue
        tv.endDate = json["last_air_date"].stringValue
        tv.numberOfEpisodes = json["number_of_episodes"].intValue
        tv.numberOfSeason = json["number_of_seasons"].intValue
        
        
        tv.actors = getActors(json, root: "credits", subRoot: "cast")
        
        
        
        

        let genres = json["genres"]
        tv.genre = [String]()
        
        for gen in genres {
            tv.genre?.append(gen.1["name"].stringValue)
        }
        
        
        let seasons = json["seasons"]
        
        for (_,subJson):(String, JSON) in seasons {
           
            let season = Season(id: subJson["id"].stringValue, tvID: tv.id, title: tv.title)
            season.air_date = subJson["air_date"].stringValue
            season.episode_count = subJson["episode_count"].intValue
            season.season_number = subJson["season_number"].intValue
            season.posterURL = subJson["poster_path"].stringValue
            tv.seasons?.append(season)
        }
        
        return tv
        
        
    }

    
    func dataToEpisodes(data: NSData?) -> [Episode]{
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var episodesList = [Episode]()
        let episodes = json["episodes"]
        for (_,subJson):(String, JSON) in episodes {
            let episode = Episode(title: subJson["name"].stringValue, id: subJson["id"].stringValue)
            episode.releaseDate = subJson["air_date"].stringValue
            episode.episode_number = subJson["episode_number"].intValue
            episode.posterURL = subJson["still_path"].stringValue
            episode.season_number = subJson["season_number"].intValue
            episodesList.append(episode)
        }
        return episodesList
    }

    
    func dataToEpisode(data: NSData?) -> Episode{
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let episode = Episode(title: json["name"].stringValue, id: json["id"].stringValue)
        episode.releaseDate = json["air_date"].stringValue
        episode.episode_number = json["episode_number"].intValue
        episode.posterURL = json["still_path"].stringValue
        episode.plot = json["overview"].stringValue
        episode.season_number = json["season_number"].intValue
        let guestStars = getActors(json, root: "guest_stars")
        var actors = getActors(json, root: "credits", subRoot: "cast")
        for actor in guestStars {
            actors.append(actor)
        }
        
        episode.actors = actors
        return episode
        
    }

    
    func dataToCharacterList(data: NSData?) -> [Character]{
        
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        return getActors(json, root: "cast", subRoot: "character")
    }
    
}
