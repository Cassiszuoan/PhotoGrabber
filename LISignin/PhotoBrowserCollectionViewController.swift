//
//  PhotoBrowserCollectionViewController.swift
//  PhotoGrabber
//
//  Created by JerryMAc on 2016/5/5.
//  Copyright © 2016年 Jerry Lee. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import Haneke
import SwiftyJSON



private let screenBound = UIScreen.mainScreen().bounds
private var screenWidth: CGFloat { return screenBound.size.width }
private var screenHeight: CGFloat { return screenBound.size.height }


struct Media {
    
    var imageURL: NSURL!
    
}



class PhotoBrowserCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SKPhotoBrowserDelegate {

   
    
    
    var medialist = [Media]()
    private let reuseIdentifier = "InstagramCell"
    var images = [SKPhoto]()
    var urlList = [NSURL]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self

        getMediaFromInstagram()
        
        
       
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes


        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    
   
       
    
    func getMediaFromInstagram(){
        
        
        let cache = Cache<Haneke.JSON>(name: "instagram")
        let URL = NSURL(string: "https://api.instagram.com/v1/users/self/media/recent/?access_token=1577358859.22153eb.500e1815408d44ffa60bd56be2432523")!
        
        cache.fetch(URL: URL).onSuccess { JSON in
         
            let json = SwiftyJSON.JSON(JSON.dictionary["data"]!)
            
            if let array = json.array {
                for d in array {
                    let media = Media(imageURL: d["images"]["standard_resolution"]["url"].URL)
                    
                    self.medialist.append(media)
                    self.collectionView.reloadData()
                    
                    
                }
            }
            
            
            for i in self.medialist {
                
                let stringurl = i.imageURL!.absoluteString
                
                
                let photo = SKPhoto.photoWithImageURL(stringurl)
                
                self.images.append(photo)
                self.urlList.append(i.imageURL!)
                self.collectionView.reloadData()
                
                
                
                
            }
                
            }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: UICollectionViewDataSource


     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(images.count)
        return images.count
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InstagramCollectionViewCell
        // Configure the cell
        
        
       
        
        cell.imageView.hnk_setImageFromURL(urlList[indexPath.row])
        
        return cell
    
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return CGSize(width: screenWidth/2 - 5, height: 300)
        } else {
            return CGSize(width: screenWidth/2 - 5, height: 200)
        }
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! InstagramCollectionViewCell
    
        let originImage = cell.imageView.image
        let browser = SKPhotoBrowser(originImage: originImage!, photos: images, animatedFromView: cell)
       browser.initializePageIndex(indexPath.row)
        browser.delegate = self
//
//        browser.statusBarStyle = .LightContent
       browser.bounceAnimation = true
//        
//        // Can hide the action button by setting to false
       browser.displayAction = true
        
        // delete action(you must write `removePhoto` delegate, what resource you want to delete)
        // browser.displayDeleteButton = true
        
        // Optional action button titles (if left off, it uses activity controller
        // browser.actionButtonTitles = ["Do One Action", "Do Another Action"]
        
        presentViewController(browser, animated: true, completion: {})
    }
    
    
    // MARK: - SKPhotoBrowserDelegate
    func didShowPhotoAtIndex(index: Int) {
        collectionView.visibleCells().forEach({$0.hidden = false})
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = true
    }
    
    func willDismissAtPageIndex(index: Int) {
        collectionView.visibleCells().forEach({$0.hidden = false})
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = true
    }
    
    func willShowActionSheet(photoIndex: Int) {
        // do some handle if you need
    }
    
    func didDismissAtPageIndex(index: Int) {
        collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))?.hidden = false
    }
    
    func didDismissActionSheetWithButtonIndex(buttonIndex: Int, photoIndex: Int) {
        // handle dismissing custom actions
    }
    
    func removePhoto(browser: SKPhotoBrowser, index: Int, reload: (() -> Void)) {
        reload()
    }
    
    func viewForPhoto(browser: SKPhotoBrowser, index: Int) -> UIView? {
        
        return collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    
    

    

}
