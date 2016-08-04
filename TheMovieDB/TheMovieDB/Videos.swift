//
//  Videos.swift
//  
//
//  Created by Alon Green on 28/07/2016.
//
//

import Foundation
import CoreData


class Videos: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func saveVideoInfo(video: Video, inManagedObjectContext context: NSManagedObjectContext) -> Videos?{
       
        if let videoInfo = fetchVideo(video,inManagedObjectContext: context){
            return videoInfo
        }
        
        if let videoInfo = NSEntityDescription.insertNewObjectForEntityForName("Videos", inManagedObjectContext: context) as? Videos
        {
            videoInfo.unique_id = video.id
            videoInfo.director = video.director
            videoInfo.low_res_poster_url = video.lowResPosterURL
            videoInfo.plot = video.plot
            videoInfo.poster_url = video.posterURL
            videoInfo.rating = video.rating
            videoInfo.release_date = video.releaseDate
            videoInfo.runtime = String(video.runtime!.characters.dropLast(3))
            videoInfo.title = video.title
            videoInfo.video_type = String(video.videoType)
            videoInfo.voters = video.voters
          

            videoInfo.genre = video.genre?.joinWithSeparator(",")
            var index: Int = 0
            var actors: Set<Actors> = Set()
            for actor in video.actors! {
                actors.insert(Actors.saveActorInfo(actor, index: index, inManagedObjectContext: context)!)
                index = index + 1
                
            }
            
            videoInfo.actors = actors
            
            switch video.videoType
            {
            case .Movie:
                let tmdbMovie = video as! TmdbMovie
                videoInfo.imdb_id = tmdbMovie.imdbID
            case .TV:
                let tv = video as! TmdbTV
                videoInfo.imdb_id = tv.imdbID
                videoInfo.number_of_season = tv.numberOfSeason
                videoInfo.number_of_episodes = tv.numberOfEpisodes
                videoInfo.end_date = tv.endDate
            case .Episode:
                let episode = video as! Episode
                videoInfo.episode_number =  episode.episode_number
                videoInfo.season_number = episode.season_number
                
            }
            return videoInfo
        }
        return nil
    }
    
    
    class func fetchVideo(video: Video, inManagedObjectContext context: NSManagedObjectContext) -> Videos?{
        let request =  NSFetchRequest(entityName: "Videos")
        request.predicate = NSPredicate(format: "unique_id = %@", video.id)
        
        if let videoInfo = (try? context.executeFetchRequest(request))?.first as? Videos{
            return videoInfo
        }
        return nil
    }
    
    class func deleteVideo(video: Video, inManagedObjectContext context: NSManagedObjectContext) -> Bool{
        
        if let videoInfo = fetchVideo(video, inManagedObjectContext: context){
            context.deleteObject(videoInfo)
            return true
        }
        return false
    }
    
}
   