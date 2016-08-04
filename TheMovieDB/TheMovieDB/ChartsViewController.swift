//
//  ChartsViewController.swift
//  TheMovieDB
//
//  Created by Alon Green on 10/05/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit
import AlamofireImage

class ChartsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UIScrollViewDelegate{

    
    //MARK: Outlets
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var resultPerRequest:Int = 20
    
    //MARK: Properties
    var webAPI: WebAPIDelegate?
    var movies: VideosList?
    private var importingData = false
    
    //MARK: ViewControllers Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        
        webAPI = WebFactory.getWebAPI(WebAPI.TMDB)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
       
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
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
        importingData = true
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
    func reloadData(newMovies: VideosList){
        importingData = false
        if self.movies == nil{
             self.movies = newMovies
        }
        else
        {
            self.movies?.add(newMovies.videos)
        }
        self.collectionView.reloadData()
    }

    
    @IBAction func segmentControlModified(sender: UISegmentedControl)
    {
        self.movies = nil
        fetchMovies()
    }
    
    
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if movies == nil{
            return 0
        }
        return (movies!.count())
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let movieCell = cell as? CollectionViewCell else {return}
        if let movie = movies!.getMovie(indexPath.row){
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
            fetchMovies(movieCount / self.resultPerRequest + 1)
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
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let movieCell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! CollectionViewCell
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
            let movie = movies!.getMovie(indexPath.row)
           // print("id = \(movie.id), title = \(movie.title)")
            collectionView.allowsSelection = false
            webAPI?.fetchDetailedMovieInfo(movie!.id, completionHandler: loadVideoInfo)
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
