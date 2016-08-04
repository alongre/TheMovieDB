//
//  TVSeasonsTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 24/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage




class TVSeasonsTableViewController: UITableViewController {

    //MARK: Properties
    
    var tv: TmdbTV?
    var tvSeason: [Season]?
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = tv?.title
        tvSeason = tv?.seasons
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
//    func sort()
//    {
//        self.tvSeason?.sortInPlace({ $1.air_date > $0.air_date })
//        
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (tvSeason?.count)!
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = cell as? SeasonTableViewCell else {return}
        let season = tvSeason![indexPath.row]
        
        cell.seasonNumberLabel.text = String(season.season_number!)
        cell.episodeCountLabel.text = String(season.episode_count!)
        cell.airDateLabel.text = String(season.air_date!)
       
        
        
        if season.lowResPosterURL == "N/A"{
            cell.posterImage.image = UIImage(named: "no_image")
        }
        else{
            let URL = NSURL(string: season.lowResPosterURL!)!
            cell.posterImage.af_setImageWithURL(URL)
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SeasonCell", forIndexPath: indexPath) as! SeasonTableViewCell
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let season = tv?.seasons![indexPath.row]
        tableView.allowsSelection = false
        WebFactory.getWebAPI(WebAPI.TMDB).fetchTVEpisodes((tv?.id)!, season: (season?.season_number)!, completionHandler: loadEpisodesInfo)
    }
    
    
    //MARK: - Segue
    func loadEpisodesInfo(episodes: [Episode])
    {
        
        let season = tv?.seasons![(tableView.indexPathForSelectedRow?.row)!]
        
        if let episodesTVC = storyboard?.instantiateViewControllerWithIdentifier("EpisodeList") as? EpisodesTableViewController {
           
            episodesTVC.episodes = episodes
            episodesTVC.tv = tv
            episodesTVC.season = season
            tableView.allowsSelection = true
            navigationController?.pushViewController(episodesTVC, animated: true)
        }
        
        
        
    }

}
