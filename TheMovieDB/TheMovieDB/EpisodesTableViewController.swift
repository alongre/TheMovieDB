//
//  EpisodesTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 24/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage



class EpisodesTableViewController: UITableViewController {

    //MARK: Properties
    
    var episodes: [Episode]?
    var season: Season?
    var tv: TmdbTV?
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = season?.description
       
        // sort()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
   
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (episodes?.count)!
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = cell as? EpisodeTableViewCell else {return}
        let episode = episodes![indexPath.row]
        
        cell.airDateLabel.text = String(episode.releaseDate!)
        cell.episodeNameLabel.text = String(episode.title)
        cell.episodeNumberLabel.text = String(episode.episode_number!)
        
        
        
        if episode.lowResPosterURL == "N/A"{
            cell.posterImage.image = UIImage(named: "no_image")
        }
        else{
            let URL = NSURL(string: episode.lowResPosterURL!)!
            cell.posterImage.af_setImageWithURL(URL)
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EpisodeCell", forIndexPath: indexPath) as! EpisodeTableViewCell
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let episode = episodes![indexPath.row]
        tableView.allowsSelection = false
         WebFactory.getWebAPI(WebAPI.TMDB).fetchTVEpisode((tv?.id)!, season: episode.season_number!, episode: episode.episode_number!, completionHandler: loadEpisodeInfo)
        
    }
    
    
    //MARK: - Segue
    func loadEpisodeInfo(episode: Episode)
    {
        
        if let videoDetailVC = storyboard?.instantiateViewControllerWithIdentifier("VideoInfo") as? VideosInfoTableViewController {
            episode.runtime = tv?.runtime?.stringByReplacingOccurrencesOfString("min", withString: "")
            videoDetailVC.video = episode
            tableView.allowsSelection = true
            navigationController?.pushViewController(videoDetailVC, animated: true)
        }
        
        
        
    }

}
