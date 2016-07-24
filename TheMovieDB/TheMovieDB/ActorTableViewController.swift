//
//  ActorTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 03/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage
import SDWebImage

class ActorTableViewController: UITableViewController {

    
    //MARK: Properties

    var actors: [Character]?
    
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Actors"
        
        
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
        return (actors?.count)!
    }

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
      
        guard let cell = cell as? ActorTableViewCell else {return}
        
        let actor = actors![indexPath.row]
        cell.actorName.text = actor.Name
        cell.characterName.text = actor.CharacterName
        
        if actor.posterURL == "N/A"{
            cell.actorPoster.image = UIImage(named: "no_image")
        }
        else
        {
            let URL = NSURL(string: actor.posterURL!)!
            cell.actorPoster.af_setImageWithURL(URL)
            
        }

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActorCell", forIndexPath: indexPath) as! ActorTableViewCell
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let actor = actors![indexPath.row]
        tableView.allowsSelection = false
        WebFactory.getWebAPI(WebAPI.TMDB).fetchPersonDetail(actor.ID!, completionHandler: loadActorInfo)
    }
    
    
    //MARK: - Segue
    func loadActorInfo(actor: Character)
    {
        
        if let actorDetailVC = storyboard?.instantiateViewControllerWithIdentifier("ActorDetailsnfo") as? ActorDetailTableViewController {
            actorDetailVC.actor = actor
             tableView.allowsSelection = true
            navigationController?.pushViewController(actorDetailVC, animated: true)
        }
        
        
        
    }


}
