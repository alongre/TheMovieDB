//
//  ActorDetailTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 07/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import CoreData

class ActorDetailTableViewController: UITableViewController {

     
    //MARK - Outlets
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var birthPlaceLabel: UILabel!
    @IBOutlet weak var deathDateLabel: UILabel!
    @IBOutlet weak var plotTextView: UITextView!

    @IBOutlet weak var films: UITextView!
    
    
    //MARK: Properties

    var mangedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var actor: Character?
    var movies: VideosList?
    
    
    //MARK: - Life Cycle view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(_:)))

        posterImage.userInteractionEnabled = true
        posterImage.addGestureRecognizer(tapGestureRecognizer)
      

        updateDBButton()
        
        reloadData()
    }
    
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        plotTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.screenRotated(fromInterfaceOrientation)
    }

    
    
    func updateDBButton(){
        
        
        navigationItem.rightBarButtonItems?.removeAll()
        let rightBarButton = UIBarButtonItem()
        navigationItem.rightBarButtonItem = rightBarButton
            
        
        
    }

    
    
    //MARK: - Load Data
    
    func reloadData(){
        
    
        if let actor = actor{
            self.navigationItem.title = actor.Name
            if actor.posterURL == "N/A"{
                posterImage.image = UIImage(named: "no_image")
            }
            else{
                
                let URL = NSURL(string: actor.posterURL!)!
                posterImage.af_setImageWithURL(URL)
            }
            birthdateLabel.text = actor.Birthday
            birthPlaceLabel.text = actor.Birthplace
            deathDateLabel.text = actor.DeathDay
            
            plotTextView.text = actor.Biography
            plotTextView.scrollRangeToVisible(NSMakeRange(0, 0))
            self.films.text = "Filmography"
            
            
        }
    }
    
    func loadFilmogrofy(){
        WebFactory.getWebAPI(WebAPI.TMDB).fetchPersonMovies(actor!.ID!, completionHandler: loadFilmsInfo)
    }
    
    
    //MARK: - Table view methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1{
            WebFactory.getWebAPI(WebAPI.TMDB).fetchPersonMovies(actor!.ID!, completionHandler: loadFilmsInfo)
        }
    }

    
    //MARK: - Segue
    func loadFilmsInfo(movies: VideosList)
    {
        
        
        if let searchVC = storyboard?.instantiateViewControllerWithIdentifier("SearchData") as? SearchTableViewController {
            searchVC.movies = movies
            navigationController?.pushViewController(searchVC, animated: true)
        }
        

        
        
    }

    
}
