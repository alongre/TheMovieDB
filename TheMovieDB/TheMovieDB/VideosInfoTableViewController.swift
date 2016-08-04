//
//  VideosInfoTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 23/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

class VideosInfoTableViewController: UITableViewController {

    
    
    //MARK: - Outlets
    
     var mangedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
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

        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(_:)))
        posterImage.userInteractionEnabled = true
        posterImage.addGestureRecognizer(tapGestureRecognizer)
       
        
        reloadData()
        updateDBButton()
  }
    
    
    func updateDBButton(){
       
        
        navigationItem.rightBarButtonItems?.removeAll()
        if video?.videoType == VideoType.Episode{
            let rightBarButton = UIBarButtonItem()
           
            
            navigationItem.rightBarButtonItem = rightBarButton
            
        }
        else if ((Videos.fetchVideo(video!, inManagedObjectContext: self.mangedObjectContext!)) != nil){
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self,action:#selector(self.deleteVideo(_:)))
        }
        else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self,action:#selector(self.saveVideo(_:)))
        }
        
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
            if indexPath.row == Row.Cast.rawValue{
                if video?.actors != nil{
                    loadActorsInfo((video?.actors)!)
                }
            }
        }
        else{
            
            guard let tv = video as? TmdbTV else {return}
            if tv.seasons?.count == 0{
                  WebFactory.getWebAPI(WebAPI.TMDB).fetchDetailedTVInfo(tv.id, completionHandler: loadSeasonInfo)
            }
            else{
                
            
                loadSeasonInfo(tv)
            }
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
    
    
    
    
    //MARK: - Core Date
    func saveVideo(sender: AnyObject){
        
        mangedObjectContext?.performBlock{
            _ = Videos.saveVideoInfo(self.video!, inManagedObjectContext: self.mangedObjectContext!)
            do{
                try self.mangedObjectContext?.save()
                self.displayMessage("Video was added to My Videos")
                self.updateDBButton()
            } catch let error{
              print("Core Data Error \(error)")
            }
        }
        
        
    }
    
    func deleteVideo(sender: AnyObject){
        
        mangedObjectContext?.performBlock{
            _ = Videos.deleteVideo(self.video!, inManagedObjectContext: self.mangedObjectContext!)
            do{
                try self.mangedObjectContext?.save()
                self.displayMessage("Video was removed from My Favorites")
                self.updateDBButton()
            } catch let error{
                print("Core Data Error \(error)")
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
                dateLabel.text = (newVideo as! TmdbTV).tvPeriod
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
    
    func updateIMDBDetails(fetchedVideo: Video){
        
        votersLabel.text = fetchedVideo.voters
          ratingLabel.text = fetchedVideo.rating
        directorTextView.text = fetchedVideo.director
        
        video?.rating = fetchedVideo.rating
        video?.voters = fetchedVideo.voters
        video?.director = fetchedVideo.director
  }

    
    //MARK: - Segue
    func loadActorsInfo(actors: [Character])
    {
        
        if let actorListTVController = storyboard?.instantiateViewControllerWithIdentifier("ActorsList") as? ActorTableViewController {
            actorListTVController.actors = actors
            navigationController?.pushViewController(actorListTVController, animated: true)
        }
        
        
        
    }
   
    func loadSeasonInfo(video: Video)
    {
        
        if let seasonTVController = storyboard?.instantiateViewControllerWithIdentifier("SeasonList") as? TVSeasonsTableViewController {
            
            seasonTVController.tv = (video as! TmdbTV)
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





