//
//  VideosInfoTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 23/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage

class VideosInfoTableViewController: UITableViewController {

    
    
    //MARK: - Outlets
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var votersLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var actorsTextView: UITextView!
    @IBOutlet weak var directorTextView: UITextView!
    @IBOutlet weak var tvSeasonsTextView: UITextView!
    //MARK: - Stored Properties
    var video: Video?
    
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  tableView.estimatedRowHeight = 100
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(_:)))
        posterImage.userInteractionEnabled = true
        posterImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        reloadData()
  }
    
    
    
      override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        plotTextView.setContentOffset(CGPointZero, animated: false)
    }
    
   
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.screenRotated(fromInterfaceOrientation)
    }
        
    //MARK: - Table view methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            WebFactory.getWebAPI(WebAPI.TMDB).fetchCastList((video?.id)!, completionHandler: loadVideoInfo)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        else{
            if video?.videoType == VideoType.TV{
                return 1
            }
            else{
                return 0
            }
        }
    }
    
    //MARK: - Load data into controller
    
    func reloadData(){
      
        
        
        if let newVideo = video{
            
            
            
            self.navigationItem.title = newVideo.title
            if newVideo.posterURL == "N/A"{
                posterImage.image = UIImage(named: "no_image")
            }
            else{
                
                let URL = NSURL(string: newVideo.posterURL!)!
                posterImage.af_setImageWithURL(URL)
            }
           
            runtimeLabel.text = newVideo.runtime
            plotTextView.text = newVideo.plot
            plotTextView.scrollRangeToVisible(NSMakeRange(0, 0))
            loadGenres()
            
            
            dateLabel.text = newVideo.releaseDate
            
        
            loadDataFromIMDB()
            if newVideo.videoType == VideoType.TV{
                tvSeasonsTextView.text = newVideo.description
            }

            
        }
        
        
    }
    
    private func loadActors(actors: [Character]?){
        actorsTextView.text.removeAll()
        var actorList: String = ""
        if let actors = actors{
            for actor in actors {
                actorList = actorList + actor.Name! + ","
            }
            if actorList.characters.count > 0{
                actorsTextView.text = String(actorList.characters.dropLast())
            }
            
        }
        
    }
    
    private func loadGenres(){
        genreLabel.text?.removeAll()
        var genreList: String = ""
        if let genres = video!.genre{
            for genre in genres {
                genreList = genreList + genre + ","
            }
            if genreList.characters.count > 0{
                genreLabel.text? = String(genreList.characters.dropLast())
            }
        }
    }
    
    
    private func loadDataFromIMDB(){
        
        var imdbID: String
        if video?.videoType == VideoType.Movie{
            imdbID = (video as! TmdbMovie).imdbID
        }
        else{
            imdbID = (video as! TmdbTV).imdbID
        }
        
    
        
            if imdbID.characters.count > 0 {
                WebFactory.getWebAPI(WebAPI.IMDB).fetchDetailedVideoInfo(imdbID, completionHandler: updateIMDBDetails)
                return
            }
        
        
        votersLabel.text = video!.voters
        ratingLabel.text = video!.rating
        directorTextView.text = video!.director
        loadActors(video!.actors)

        
    }
    
    func updateIMDBDetails(video: Video){
        loadActors(video.actors)
        votersLabel.text = video.voters
        ratingLabel.text = video.rating
        directorTextView.text = video.director

        
    }

    
    //MARK: - Segue
    func loadVideoInfo(actors: [Character])
    {
        
        if let actorListTVController = storyboard?.instantiateViewControllerWithIdentifier("ActorsList") as? ActorTableViewController {
            actorListTVController.actors = actors
            navigationController?.pushViewController(actorListTVController, animated: true)
        }
        
        
        
    }

    
}

