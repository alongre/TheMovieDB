//
//  Actors+CoreDataProperties.swift
//  TheMovieDB
//
//  Created by Alon Green on 04/08/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Actors {

    @NSManaged var bio: String?
    @NSManaged var birthday: String?
    @NSManaged var birthplace: String?
    @NSManaged var character_name: String?
    @NSManaged var death_day: String?
    @NSManaged var index: NSNumber?
    @NSManaged var low_res_poster_url: String?
    @NSManaged var name: String?
    @NSManaged var position: String?
    @NSManaged var poster_url: String?
    @NSManaged var unique_id: String?
    @NSManaged var videos: NSSet?

}
