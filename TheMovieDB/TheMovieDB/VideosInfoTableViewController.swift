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
    var movie: Movie?
    
    
    
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
            WebFactory.getWebAPI(WebAPI.TMDB).fetchCastList((movie?.id)!, completionHandler: loadVideoInfo)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        else{
            if tvSeasonsTextView.text.characters.count > 0{
                return 1
            }
            else{
                return 0
            }
        }
    }
    
    //MARK: - Load data into controller
    
    func reloadData(){
      
        
        if let movie = movie{
            
                      self.navigationItem.title = movie.title
            if movie.posterURL == "N/A"{
                posterImage.image = UIImage(named: "no_image")
            }
            else{
                
                let URL = NSURL(string: movie.posterURL!)!
                posterImage.af_setImageWithURL(URL)
            }
            dateLabel.text = movie.releaseDate
            runtimeLabel.text = movie.runtime!
            plotTextView.text = movie.plot
            plotTextView.scrollRangeToVisible(NSMakeRange(0, 0))

            
            
            loadGenres()           
            loadDataFromIMDB()
            
          
            
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
        if let genres = movie!.genre{
            for genre in genres {
                genreList = genreList + genre + ","
            }
            if genreList.characters.count > 0{
                genreLabel.text? = String(genreList.characters.dropLast())
            }
        }
    }
    
    
    private func loadDataFromIMDB(){
        if let tmdbMovie = movie as? TmdbMovie{
            if tmdbMovie.imdbID.characters.count > 0 {
                WebFactory.getWebAPI(WebAPI.IMDB).fetchDetailedVideoInfo(tmdbMovie.imdbID, completionHandler: updateIMDBDetails)
                return
            }
        }
        
        votersLabel.text = movie!.voters
        ratingLabel.text = movie!.rating
        directorTextView.text = movie!.director
        loadActors(movie!.actors)

        
    }
    
    func updateIMDBDetails(movie: Movie){
        loadActors(movie.actors)
        votersLabel.text = movie.voters
        ratingLabel.text = movie.rating
        directorTextView.text = movie.director

        
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

