//
//  SearchTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 07/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    
    var refreshControl: UIRefreshControl!
    
    //MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Properties
    var webAPI: WebAPIDelegate?
    var movies: [Video]?
    var pageIndex: Int = 0
    var imageCache = [String:UIImage]()
    private var lastVideoCount: Int = 0;
    private var resultPerRequest:Int?
    
    //MARK: Actions
    @IBAction func segmentControlModified(sender: UISegmentedControl)
    {
        self.movies?.removeAll()
        
        fetchVideos()
    }

    
    
    //MARK: Lifecycle events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        webAPI = WebFactory.getWebAPI(WebAPI.TMDB)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to sort")
        refreshControl.addTarget(self, action: #selector(SearchTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.tableViewTapped(_:)))
        
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(tapGestureRecognizer)

        
        
        pageIndex = 1
        
        if movies?.count > 0{
           // updateImageCache()
            sortVideos()
        }
        
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    func updateImageCache(){
//        for video in movies! {
//            print(video.id)
//            let keyExists = imageCache[video.id] != nil
//            if keyExists == false{
//                let imageView = UIImageView()
//                let URL = NSURL(string: video.posterURL!)!
//               // imageView.af_imageDownloader?.downloadImage(URLRequest: URL, completion: <#T##CompletionHandler?##CompletionHandler?##Response<Image, NSError> -> Void#>)(URL)
//                imageView.af_setImageWithURL(URL)
//                imageCache[video.id] = imageView
////                
////                
//            }
//        }
//    }
    
    func tableViewTapped(tap:UITapGestureRecognizer)
    {
      
        let location = tap.locationInView(self.tableView)
        let path = self.tableView.indexPathForRowAtPoint(location)
        if let indexPathForRow = path {
            self.tableView(self.tableView, didSelectRowAtIndexPath: indexPathForRow)
        } else {
             self.searchBar.resignFirstResponder()
        }
        
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        sortVideos()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

   
    func sortVideos()
    {
        self.movies?.sortInPlace({ $0.releaseDate > $1.releaseDate })

    }
    
    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        self.searchBar.resignFirstResponder()
        self.movies = [Video]()
        fetchVideos()
        
    }
    

    
    
    func reloadData(movies: [Video]){
    //  self.resultPerRequest = movies.count
      self.movies?.appendContentsOf(movies)
    
      self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let movies = movies{
            return movies.count
        }
        return 0
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCellWithIdentifier(Constants.MOVIES_TABLE_VIEW_CELL_INDENTIFIER, forIndexPath: indexPath) as! MovieTableViewCell
        
        
        let movie = movies![indexPath.row]
        
        movieCell.titleLabel?.text = movie.title
        movieCell.yearLabel?.text = movie.releaseDate
        movieCell.ratingLabel?.text = movie.rating
        if movie.posterURL == "N/A"{
             movieCell.posterImage.image = UIImage(named: "no_image")
        }
        else{
          
            
            if let imageView = imageCache[movie.id]{
                movieCell.posterImage.image = imageView
            }
            else
            {
                let URL = NSURL(string: movie.posterURL!)!
                movieCell.posterImage.af_setImageWithURL(URL)
                imageCache[movie.id] = movieCell.posterImage.image
            }

        }
        
        
        
        if (indexPath.row == (movies?.count)! - 5){
        //    var pageIndex = (movies?.count)! / self.resultPerRequest! + 1
          //  if (pageIndex < 1){
           //     pageIndex = 2
            //}
            if movies?.count > lastVideoCount{
                lastVideoCount = (movies?.count)!
                pageIndex += 1
                webAPI?.fetchMovies(searchBar.text!,pageIndex: pageIndex, completionHandler: reloadData)
            }
        }
        // Configure the cell...

        return movieCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let movie = movies![indexPath.row] as Video
        switch segmentControl.selectedSegmentIndex {
        case 0:
            webAPI?.fetchDetailedVideoInfo(movie.id, completionHandler: loadVideoInfo)
        case 1:
            webAPI?.fetchDetailedTVInfo(movie.id, completionHandler: loadVideoInfo)

        default:
            return
        }
        
        
         tableView.deselectRowAtIndexPath(indexPath, animated: true)

        
    }
    
       
    
    //MARK: fetch data
    
    func fetchVideos(pageIndex: Int? = 1){
        
        if let search = searchBar.text {
            if search.characters.count == 0 {
                return
            }
            switch segmentControl.selectedSegmentIndex {
            case 0:
                webAPI?.fetchMovies(search,pageIndex: pageIndex, completionHandler: reloadData)
            case 1:
                webAPI?.fetchTVShows(search,pageIndex: pageIndex, completionHandler: reloadData)
            default:
                return
            }
        }
    }

    
    //MARK: Segue
    
    func loadVideoInfo(movie: Video)
    {
        
        if let videoInfo = storyboard?.instantiateViewControllerWithIdentifier("VideoInfo") as? VideosInfoTableViewController {
            videoInfo.video = movie
            navigationController?.pushViewController(videoInfo, animated: true)
        }
        
    }
    
   
}
