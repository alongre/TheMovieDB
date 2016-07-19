//
//  TableVCExtension.swift
//  TheMovieDB
//
//  Created by Alon Green on 16/07/2016.
//  Copyright © 2016 Alon Green. All rights reserved.
//

import UIKit


extension UITableViewController{
    
   
    
    //MARK: - Enlarge image when tapping

    func imageTapped(sender: AnyObject)
    {
        
        
        let tap = sender as! UITapGestureRecognizer
        if let posterImage = tap.view as? UIImageView{
        
            let newImageView = UIImageView(image: posterImage.image)
            newImageView.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
            newImageView.clipsToBounds = true
            newImageView.backgroundColor = .blackColor()
            newImageView.contentMode = .ScaleAspectFit
            newImageView.tag = Constants.LARGE_IMAGE_ID
            newImageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(_:)))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            
            addSaveBarButton()
        }
        
    }
    
    
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        let view = self.view?.viewWithTag(Constants.LARGE_IMAGE_ID)
        view?.removeFromSuperview()
        self.navigationItem.rightBarButtonItems?.removeAll()
    }
    
    
    //MARK: - Save Image
    
    func addSaveBarButton(){
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action:#selector(self.saveImage))
        self.navigationItem.rightBarButtonItem = saveBtn
        
    }
    
    
    func saveImage(){
        let view = self.view?.viewWithTag(Constants.LARGE_IMAGE_ID)
        if let posterImage = view as? UIImageView{
            let imageData = UIImageJPEGRepresentation(posterImage.image!, 0.6)
            let compressedJPGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
            
            
            let alertController = UIAlertController(title: "TheMovieDB", message: "Your image has been saved to Photo Library!", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil )
        }
    }


    //MARK: - handle image rotation
    func screenRotated(fromInterfaceOrientation: UIInterfaceOrientation) {
        let view = self.view?.viewWithTag(Constants.LARGE_IMAGE_ID)
        if let imageView = view {
            imageView.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
}
