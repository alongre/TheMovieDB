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
        
        let request =  NSFetchRequest(entityName: "Videos")
        request.predicate = NSPredicate(format: "unique = %@", video.id)
        
        if let videoInfo = (try? context.executeFetchRequest(request))?.first as? Videos{
            return videoInfo
        }else if let videoInfo = NSEntityDescription.insertNewObjectForEntityForName("Videos", inManagedObjectContext: context) as? Videos{
            videoInfo.unique_id = video.id
            videoInfo.director = video.director
            videoInfo.low_res_poster_url = video.lowResPosterURL
            videoInfo.plot = video.plot
            videoInfo.poster_url = video.lowResPosterURL
            videoInfo.rating = video.rating
            videoInfo.release_date = video.releaseDate
            videoInfo.runtime = video.runtime
            videoInfo.title = video.title
            videoInfo.video_type = String(video.videoType)
            videoInfo.voters = video.voters
            videoInfo.genre = video.genre?.description
            
            switch video.videoType {
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
        
            default:
                break
            }
            
        }
        
        
        return nil
    }
    
    
}
