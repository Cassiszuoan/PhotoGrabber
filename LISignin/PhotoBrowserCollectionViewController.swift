//
//  PhotoBrowserCollectionViewController.swift
//  PhotoGrabber
//
//  Created by JerryMAc on 2016/5/5.
//  Copyright © 2016年 Jerry Lee. All rights reserved.
//

import UIKit
import SKPhotoBrowser



private let screenBound = UIScreen.mainScreen().bounds
private var screenWidth: CGFloat { return screenBound.size.width }
private var screenHeight: CGFloat { return screenBound.size.height }
private let reuseIdentifier = "InstagramCell"
var images = [SKPhoto]()


class PhotoBrowserCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SKPhotoBrowserDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes


        // Do any additional setup after loading the view.
        
        let photo = SKPhoto.photoWithImageURL("https://placehold.jp/150x150.png")
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        images.append(photo)
        images.append(photo)
        images.append(photo)
        images.append(photo)
        images.append(photo)
        images.append(photo)
        images.append(photo)
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    // MARK: UICollectionViewDataSource


     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
       
        return images.count
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InstagramCollectionViewCell
        // Configure the cell
        
        let image = NSData(contentsOfURL:NSURL(string: images[indexPath.row].photoURL)!)
        cell.imageView.image = UIImage(data: image!)
        
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
