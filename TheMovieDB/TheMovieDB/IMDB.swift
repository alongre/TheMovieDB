//
//  IMDB.swift
//  TheMovieDB
//
//  Created by Alon Green on 07/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class IMDB: WebAPIDelegate{
    
    let CLASS_NAME = "IMDB"
    
    
    
    func fetchMovies(searchString:String, pageIndex:Int?, completionHandler: ([Video]) -> Void){
       
        
        var index = 1
        if let pageIndex = pageIndex {
           index = pageIndex
        }
         let url = NSURL(string: Constants.IMDB_API)

        let paramDictionary: [String:String] = ["s":searchString,
                               "type":"movie",
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
    
    func fetchTVShows(searchString:String, pageIndex:Int?, completionHandler: ([Video]) -> Void){
        
        
        var index = 1
        if let pageIndex = pageIndex {
            index = pageIndex
        }
        let url = NSURL(string: Constants.IMDB_API)
        
        let paramDictionary: [String:String] = ["s":searchString,
                                                "type":"series",
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

    func fetchDetailedVideoInfo(id:String,completionHandler: (Video) -> Void){
        
        
        let url = NSURL(string: Constants.IMDB_API)
        
        let paramDictionary: [String:String] = ["i":id,
                                                "plot":"short"]
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
        
    }
    
    func fetchMoviesWithURL(url: String,pageIndex: Int?,completionHandler: ([Video]) -> Void){
        
    }
    
    func fetchPersonDetail(id: String, completionHandler: (Character) -> Void){
        
    }

    
    func fetchPersonMovies(id: String, completionHandler: ([Video]) -> Void){
    }
    
    
    func dataToMovies(data:NSData?) -> [Video] {
        var movies = [Video]()
        
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let isDataExist = json["Response"]
        print(isDataExist)
        if (isDataExist != "False"){
            let results = json["Search"]
            for (_,subJson):(String, JSON) in results {
                let title = subJson["Title"].stringValue
                let imdbID = subJson["imdbID"].stringValue
                
                let movie = ImdbMovie(title: title, id: imdbID)
                movie.releaseDate = subJson["Year"].stringValue
                movie.posterURL = subJson["Poster"].stringValue
                print(movie)
                movies.append(movie)
            }
        }
        return movies
    }
    
    
    func dataToFullInfoMovie(data:NSData?) -> ImdbMovie? {
       
        let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        let isDataExist = json["Response"]
        print(isDataExist)
        if (isDataExist != "False"){
            let title = json["Title"].stringValue
            let year = json["Year"].stringValue
            let runtime = json["Runtime"].stringValue
            let genre = json["Genre"].stringValue
            let director = json["Director"].stringValue
            let actors = json["Actors"].stringValue
            let plot = json["Plot"].stringValue
            let poster = json["Poster"].stringValue
            let rating = json["imdbRating"].stringValue
            let voters = json["imdbVotes"].stringValue
            let id = json["imdbID"].stringValue
            
            let movie = ImdbMovie(title: title, id: id)
            movie.releaseDate = year
            movie.runtime = runtime
            movie.genre = [genre]
            movie.director = director
            movie.actors = getActorList(actors)
            movie.plot = plot
            movie.posterURL = poster
            movie.rating = rating
            movie.voters = voters
            
            
            print(movie)
            return movie
            
        }
        return nil
    }
    
    func getActorList(actors: String) -> [Character]{
        let actorNamesList = actors.componentsSeparatedByString(",")
        var actors = [Character]()
        for actorName in actorNamesList {
            let actor = Character(name: actorName)
            actors.append(actor)
        }
        return actors
        
    }

    
    func fetchCastList(id: String, completionHandler: ([Character]) -> Void){
        
    }

    
    
    
}

