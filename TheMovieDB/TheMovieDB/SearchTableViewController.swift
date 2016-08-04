//
//  SearchTableViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 07/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage
import AlamofireNetworkActivityIndicator

class SearchTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UIScrollViewDelegate {

    
    var refreshControl: UIRefreshControl!
    
    //MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Properties
    var webAPI: WebAPIDelegate?
    var movies: VideosList?
    private var resultPerRequest:Int = 20
    private var importingData = false

    
    //MARK: Actions
    @IBAction func segmentControlModified(sender: UISegmentedControl)
    {
        self.movies = nil
        fetchVideos()
    }

    
    
    //MARK: Lifecycle events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        webAPI = WebFactory.getWebAPI(WebAPI.TMDB)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        addPullToSort()
        addImageTapRecognizer()
        movies?.sortByDate()
    }
    
    
   
    
    //MARK: - Add pull to sort and Image tapping
    
    func addPullToSort(){
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to sort")
        refreshControl.addTarget(self, action: #selector(SearchTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    func addImageTapRecognizer(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.tableViewTapped(_:)))
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
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

   
    
    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        self.searchBar.resignFirstResponder()
        self.movies = nil
        fetchVideos()
        
    }
    
    //MARK: Scrolling methods
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (importingData == true)
        {
            return
        }
        
        if (isScrolledToTheBottom(scrollView)){
            let movieCount: Int = (movies?.count())!
            if movieCount == movies?.totalResults {
                return
            }
            let pageIndex = movieCount / self.resultPerRequest + 1
            webAPI?.fetchMovies(searchBar.text!,pageIndex: pageIndex, completionHandler: reloadData)
        }
    }
    
    
    func isScrolledToTheBottom(scrollView: UIScrollView) -> Bool{
        let scrollViewHeight = scrollView.frame.size.height;
        let scrollContentSizeHeight = scrollView.contentSize.height;
        let scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset + scrollViewHeight > scrollContentSizeHeight - 30){
            return true
        }
        return false
    }
    
    
    
    //MARK: Loading And setting data
    func reloadData(newMovies: VideosList){
        importingData = false
        if self.movies == nil{
            self.movies = newMovies
        }
        else
        {
            self.movies?.add(newMovies.videos)
        }
    
      self.tableView.reloadData()
    }
    
    func sortVideos()
    {
        self.movies!.sortByDate()
        
    }

    
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if movies == nil{
            return 0
        }
        return (movies!.count())

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let movies = movies{
            return movies.count()
        }
        return 0
    }

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
       
        guard let movieCell = cell as? MovieTableViewCell else {return}
        
        if let movie = movies!.getMovie(indexPath.row){
            
        
            movieCell.titleLabel?.text = movie.title
            movieCell.yearLabel?.text = movie.releaseDate
            movieCell.ratingLabel?.text = movie.rating
            movieCell.posterImage.image = nil
            
            if movie.lowResPosterURL == "N/A"{
                movieCell.posterImage.image = UIImage(named: "no_image")
            }
            else{
                let URL = NSURL(string: movie.lowResPosterURL!)!
                movieCell.posterImage.af_setImageWithURL(URL)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCellWithIdentifier(Constants.MOVIES_TABLE_VIEW_CELL_INDENTIFIER, forIndexPath: indexPath) as! MovieTableViewCell
        return movieCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.allowsSelection = false
        let movie = movies!.getMovie(indexPath.row)! as Video
        switch segmentControl.selectedSegmentIndex {
        case 0:
            webAPI?.fetchDetailedMovieInfo(movie.id, completionHandler: loadVideoInfo)
        case 1:
            webAPI?.fetchDetailedTVInfo(movie.id, completionHandler: loadVideoInfo)
        default:
            return
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        
    }
    
       
    
    //MARK: fetch data
    
    func fetchVideos(pageIndex: Int? = 1){
        importingData = true
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
        
        tableView.allowsSelection = true
        if let videoInfo = storyboard?.instantiateViewControllerWithIdentifier("VideoInfo") as? VideosInfoTableViewController {
            videoInfo.video = movie
            navigationController?.pushViewController(videoInfo, animated: true)
        }
        
    }
    
   
}
