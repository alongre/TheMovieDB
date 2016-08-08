//
//  Actors.swift
//  
//
//  Created by Alon Green on 28/07/2016.
//
//

import Foundation
import CoreData


class Actors: NSManagedObject {

// Insert code here to add functionality to your managed object subclass


    class func saveActorInfo(actor: Character, index: Int,inManagedObjectContext context: NSManagedObjectContext) -> Actors?{
        
        
        
        if let actorInfo = fetchActor(actor, inManagedObjectContext: context){
            print(actorInfo.name)
            return actorInfo
        }
        else if let actorInfo = NSEntityDescription.insertNewObjectForEntityForName("Actors", inManagedObjectContext: context) as? Actors
        {
            actorInfo.unique_id = actor.ID
            actorInfo.bio = actor.Biography
            actorInfo.birthday = actor.Birthday
            actorInfo.birthplace = actor.Birthplace
            actorInfo.character_name = actor.CharacterName
            actorInfo.death_day = actor.DeathDay
            actorInfo.low_res_poster_url = actor.lowResPosterURL
            actorInfo.name = actor.Name
            actorInfo.position = String(actor.JobPosition)
            actorInfo.poster_url = actor.posterURL
            actorInfo.index = index
            return actorInfo
        }
        
        
        return nil
    }
    
    class func fetchActor(actor: Character, inManagedObjectContext context: NSManagedObjectContext) -> Actors?{
        
        let request =  NSFetchRequest(entityName: "Actors")
        request.predicate = NSPredicate(format: "unique_id = %@", actor.ID!)
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        if let actorInfo = (try? context.executeFetchRequest(request))?.first as? Actors{
            print("actorInfo.name: \(actorInfo.name), index - \(actorInfo.index)")
            return actorInfo
        }
        return nil

    }

    
}



