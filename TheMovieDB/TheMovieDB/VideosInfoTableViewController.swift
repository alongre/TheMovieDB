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
        actorsTextView.setContentOffset(CGPointZero, animated: false)

    }
    
   
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.screenRotated(fromInterfaceOrientation)
    }
        
    //MARK: - Table view methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == Section.Movie.rawValue{

            if video?.actors != nil{
                loadActorsInfo((video?.actors)!)
            }
//            else{
//                
//            
//                if indexPath.row == Row.Cast.rawValue {
//                    WebFactory.getWebAPI(WebAPI.TMDB).fetchCastList((video?.id)!, videoType: (video?.videoType)!, completionHandler: loadActorsInfo)
//                }
//            }
        }
        else{
            
            guard let tv = video as? TmdbTV else {return}
            loadSeasonInfo(tv)
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.Movie.rawValue{
            return 4
        }
        else{
            if video?.videoType == VideoType.TV {
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
            loadActors(video!.actors)
            actorsTextView.scrollRectToVisible(CGRectZero, animated: false)
 
            
        }
        
        
    }
    
    private func loadActors(actors: [Character]?){
        video?.actors = actors
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
        
        if video?.videoType == VideoType.Episode{
            return
        }
        var imdbID: String
        if video?.videoType == VideoType.Movie{
            imdbID = (video as! TmdbMovie).imdbID
        }
        else{
            imdbID = (video as! TmdbTV).imdbID
        }
        
    
        
            if imdbID.characters.count > 0 {
                WebFactory.getWebAPI(WebAPI.IMDB).fetchDetailedMovieInfo(imdbID, completionHandler: updateIMDBDetails)
                return
            }
        
        
        votersLabel.text = video!.voters
        ratingLabel.text = video!.rating
        directorTextView.text = video!.director
       
        
    }
    
    func updateIMDBDetails(video: Video){
        
        votersLabel.text = video.voters
        ratingLabel.text = video.rating
        directorTextView.text = video.director

        
    }

    
    //MARK: - Segue
    func loadActorsInfo(actors: [Character])
    {
        
        if let actorListTVController = storyboard?.instantiateViewControllerWithIdentifier("ActorsList") as? ActorTableViewController {
            actorListTVController.actors = actors
            navigationController?.pushViewController(actorListTVController, animated: true)
        }
        
        
        
    }
   
    func loadSeasonInfo(tv: TmdbTV)
    {
        
        if let seasonTVController = storyboard?.instantiateViewControllerWithIdentifier("SeasonList") as? TVSeasonsTableViewController {
            seasonTVController.tv = tv
            navigationController?.pushViewController(seasonTVController, animated: true)
        }
        
        
        
    }
    
}

enum Row: Int {
    case Poster = 0
    case Director = 1
    case Cast = 2
    case Plot = 3
}

enum Section: Int {
    case Movie = 0
    case TV = 1
    
}





