//
//  SavedDataTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 30/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import CoreData

class CoreDataVideosTableViewController: CoreDataTableViewController,UISearchBarDelegate,UISearchResultsUpdating {

    
    //MARK: - Stored Properties
    var mangedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    let searchController = UISearchController(searchResultsController: nil)

    
    
    //MARK: View Controller life cycle
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "My Videos"
        
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All","Movie", "TV"]
        tableView.tableHeaderView = searchController.searchBar

        
        updateUI()
        
        
        
        
    }
    
    
     //MARK: - Update UI methods
    private func updateUI(videoType: String = "All"){
        
        if let context = mangedObjectContext{
            let request = NSFetchRequest(entityName: "Videos")
            if videoType != "All"
            {
                let predicate = NSPredicate(format: "(video_type contains [cd] %@)", videoType)
                request.predicate = predicate
            }
            request.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        else{
            fetchedResultsController = nil
        }
        
    }
   
    private func updateUIWithSearch(text: String){
        
        if let context = mangedObjectContext{
            let request = NSFetchRequest(entityName: "Videos")
            let predicate = NSPredicate(format: "(title contains [cd] %@)", text)
            request.predicate = predicate
            request.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        else{
            fetchedResultsController = nil
        }
        
    }

    
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        if searchText.characters.count == 0 {
            updateUI(scope)
        }
        else{
            updateUIWithSearch(searchText)
        }
        
        tableView.reloadData()
    }
    
    //MARK: Table view methods
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as? MovieTableViewCell
        if let movieCell = cell {
            if let videoInfo = fetchedResultsController?.objectAtIndexPath(indexPath) as? Videos{
                movieCell.titleLabel?.text = videoInfo.title
                movieCell.yearLabel?.text = videoInfo.release_date
                movieCell.ratingLabel?.text = videoInfo.rating
                if videoInfo.low_res_poster_url == "N/A"{
                    movieCell.posterImage.image = UIImage(named: "no_image")
                }
                else{
                    let URL = NSURL(string: videoInfo.low_res_poster_url!)!
                    movieCell.posterImage.af_setImageWithURL(URL)
                }
            }
            return movieCell
        }

 
        return cell!
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let video = convertToVideo(indexPath)
        if let videoInfo = storyboard?.instantiateViewControllerWithIdentifier("VideoInfo") as? VideosInfoTableViewController {
            videoInfo.video = video
            navigationController?.pushViewController(videoInfo, animated: true)
        }

        
        
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if let videoInfo = fetchedResultsController?.objectAtIndexPath(indexPath) as? Videos{
                let video = Video(title: videoInfo.title!,id: videoInfo.unique_id!)
                Videos.deleteVideo(video, inManagedObjectContext: mangedObjectContext!)
                tableView.reloadData()
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    //MARK: - Handling Video: deleting, converting to Video
    func deleteVideo(video: Video){
        
        mangedObjectContext?.performBlock{
            _ = Videos.deleteVideo(video, inManagedObjectContext: self.mangedObjectContext!)
            do{
                try self.mangedObjectContext?.save()
                self.displayMessage("Video was removed from My Favorites")
                
            } catch let error{
                print("Core Data Error \(error)")
            }
        }
        
        
    }
    

    func convertToVideo(indexPath: NSIndexPath) -> Video?{
        
        if let videoInfo = fetchedResultsController?.objectAtIndexPath(indexPath) as? Videos{
             let video = VideoFacory.generateVideo(videoInfo)
                video.releaseDate = videoInfo.release_date
                video.runtime = videoInfo.runtime
                video.director = videoInfo.director
                video.genre = videoInfo.genre?.componentsSeparatedByString(",")
                video.plot = videoInfo.plot
                video.posterURL = videoInfo.poster_url
                video.rating = videoInfo.rating
                video.actors = loadActors(videoInfo.actors!)
                if String(videoInfo.video_type!) == String(VideoType.TV) {
                    let tv = video as! TmdbTV
                    tv.endDate = videoInfo.end_date
                    tv.numberOfEpisodes = Int(videoInfo.number_of_episodes!)
                    tv.numberOfSeason = Int(videoInfo.number_of_season!)
                    return tv
                }
                if String(videoInfo.video_type!) == String(VideoType.Episode) {
                    let episode = video as! Episode
                    episode.episode_number = Int(videoInfo.episode_number!)
                    episode.season_number = Int(videoInfo.season_number!)
                    return episode

                }
                return video
        }
        return nil

    }
    
    private func loadActors(actors: NSSet) -> [Character]{
        
        var actorsList = [Character]()
        var actorArray = Array(actors)
        actorArray.sortInPlace({ Int($0.index) < Int($1.index) })
        for actorInfo in actorArray {
            let actorFromDB = actorInfo as! Actors
            let actor = Character(name: actorFromDB.name!)
            actor.ID = actorFromDB.unique_id
            actor.Biography = actorFromDB.bio
            actor.Birthday = actorFromDB.birthday
            actor.Birthplace = actorFromDB.birthday
            actor.CharacterName = actorFromDB.character_name
            actor.DeathDay = actorFromDB.death_day
            actor.posterURL = actorFromDB.poster_url
            actorsList.append(actor)
        }
        return actorsList
    }


    
}
