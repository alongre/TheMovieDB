//
//  ChartsViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 10/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage

class ChartsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    
    //MARK: Outlets
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var resultPerRequest:Int?
    
    //MARK: Properties
    var webAPI: WebAPIDelegate?
    var movies: [Video]?
    private var lastVideoCount: Int = 0;
    private var pageIndex:Int = 1;
    
    
    //MARK: ViewControllers Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               
        
        
        
        
        webAPI = WebFactory.getWebAPI(WebAPI.TMDB)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
       
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.movies = [TmdbMovie]()
        self.movies?.removeAll()
        
        fetchMovies()
        

    

    }
  
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        
        
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            flowLayout.itemSize = CGSize(width: 170, height: 220)
        } else {
            flowLayout.itemSize = CGSize(width: 292, height: 332)
        }

        
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            flowLayout.itemSize = CGSize(width: 170, height: 170)
        } else {
            flowLayout.itemSize = CGSize(width: 192, height: 192)
        }
        
        flowLayout.invalidateLayout()
    }

    
    
    
    func fetchMovies(pageIndex: Int? = 1){
        if isInternetConnectionAvailable(){
            switch segmentControl.selectedSegmentIndex {
            case 0:
                webAPI?.fetchMoviesWithURL(Constants.TMDB_MOVIE_TOP_RATED_API, pageIndex: pageIndex, completionHandler: reloadData)
            case 1:
                webAPI?.fetchMoviesWithURL(Constants.TMDB_MOVIE_POPULAR_API, pageIndex: pageIndex, completionHandler: reloadData)
                
            case 2:
                webAPI?.fetchMoviesWithURL(Constants.TMDB_MOVIE_NOW_PLAYING_API, pageIndex: pageIndex, completionHandler: reloadData)
                
            case 3:
                webAPI?.fetchMoviesWithURL(Constants.TMDB_MOVIE_UPCOMING_API, pageIndex: pageIndex, completionHandler: reloadData)
                
            default:
                return
            }
        }
    }
    func reloadData(movies: [Video]){
        self.resultPerRequest = movies.count
        print("------Movies for single request: \(movies.count)------")
        self.movies?.appendContentsOf(movies)
        print("------Total Movies: \(self.movies?.count)-------")
        self.collectionView.reloadData()
    }

    
    @IBAction func segmentControlModified(sender: UISegmentedControl)
    {
        self.movies?.removeAll()

        fetchMovies()
    }
    
    
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (movies?.count)!
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let movieCell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! CollectionViewCell
        let movie = movies![indexPath.row]
         let URL = NSURL(string: movie.posterURL!)!
        movieCell.posterImage.af_setImageWithURL(URL)
        print("row: \(indexPath.row)")
        if (indexPath.row == (movies?.count)! - 5){
            
            if movies?.count > lastVideoCount{
                lastVideoCount = (movies?.count)!
                pageIndex = pageIndex + 1
                fetchMovies(pageIndex)
            }
            
       //     var pageIndex = (movies?.count)! / self.resultPerRequest! + 1
         //   if (pageIndex < 1){
            //    pageIndex = 2
          //  }
     
            
        }
        return movieCell
        
    }

    
    func collectionView(_collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let width = CGRectGetWidth(collectionView.frame) / 3
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        if isInternetConnectionAvailable(){
            let movie = movies![indexPath.row]
            collectionView.allowsSelection = false
            webAPI?.fetchDetailedVideoInfo(movie.id, completionHandler: loadVideoInfo)
        }

        
    }
    
    
    
    func loadVideoInfo(movie: Video)
    {
        
         if let videoInfo = storyboard?.instantiateViewControllerWithIdentifier("VideoInfo") as? VideosInfoTableViewController {
            videoInfo.video = movie
            navigationController?.pushViewController(videoInfo, animated: true)
        }
        
        collectionView.allowsSelection = true

        
    }

    
    
    func isInternetConnectionAvailable() -> Bool
    {
        
        if (!Reachability.isConnectedToNetwork()){
        
        let alertController = UIAlertController(title: "Alert", message: "No Internet Connection", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel)
        { (action:UIAlertAction) in
           print("you have pressed the cancel button")}
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil )
            return false
        }
        
        return true
        
        
    }

    
    
}
