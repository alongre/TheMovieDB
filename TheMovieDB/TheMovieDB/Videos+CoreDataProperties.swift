//
//  Videos+CoreDataProperties.swift
//  TheMovieDB
//
//  Created by Alon Green on 30/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Videos {

    @NSManaged var director: String?
    @NSManaged var end_date: String?
    @NSManaged var low_res_poster_url: String?
    @NSManaged var plot: String?
    @NSManaged var poster_url: String?
    @NSManaged var rating: String?
    @NSManaged var release_date: String?
    @NSManaged var runtime: String?
    @NSManaged var title: String?
    @NSManaged var unique_id: String?
    @NSManaged var video_type: String?
    @NSManaged var voters: String?
    @NSManaged var imdb_id: String?
    @NSManaged var number_of_season: NSNumber?
    @NSManaged var season_number: NSNumber?
    @NSManaged var episode_number: NSNumber?
    @NSManaged var number_of_episodes: NSNumber?
    @NSManaged var genre: String?
    @NSManaged var actors: NSSet?

}
