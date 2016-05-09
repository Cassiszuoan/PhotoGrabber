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
import Alamofire



private let screenBound = UIScreen.mainScreen().bounds
private var screenWidth: CGFloat { return screenBound.size.width }
private var screenHeight: CGFloat { return screenBound.size.height }


struct Media {
    
    var captions: String!
    var imageURL: NSURL!
    
}


struct SearchUser {
    
    var user_id: String!
    var user_name: String!
    var media: Media?
    
}



class PhotoBrowserCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate,SKPhotoBrowserDelegate {

   
    
    private let reuseIdentifier = "InstagramCell"
    var medialist = [Media]()
    var images = [SKPhoto]()
    var urlList = [NSURL]()
    var dataSourceForSearchResult:[Media]?
    var searchBarBoundsY:CGFloat?
    var refreshControl =  UIRefreshControl()
    var searchController: UISearchController!
    var searchBarActive:Bool = false
    var searchID:String = ""
    
    
    @IBOutlet weak var SearchBarView: UIView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         
        collectionView.dataSource = self
        collectionView.delegate = self
        SearchBar.delegate = self
        
        self.collectionView.alwaysBounceVertical = true
        
        
        getMediaFromInstagram()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoBrowserCollectionViewController.updateMediaWithSearchResult), name: "updateResult", object: nil)
        
        
        
        
        
        
     
        

        
        
        
    }
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.refreshControl.addTarget(self, action:#selector(PhotoBrowserCollectionViewController.refreshcell(_:)), forControlEvents: .ValueChanged)
        
        self.collectionView.addSubview(refreshControl)
    }
    
    // MARK: Search
    func searchUserID(searchText:String) {
        
        
        
        
        let accesstoken=NSUserDefaults.standardUserDefaults().objectForKey("IGAccessToken")!
        let stringURL="https://api.instagram.com/v1/users/search?q=\(searchText)&access_token=\(accesstoken)"
        let searchUserIDcache = Cache<Haneke.JSON>(name: "searchUserID")
        searchUserIDcache.removeAll()
        let URL = NSURL(string: stringURL)!
        
        
        searchUserIDcache.fetch(URL: URL).onSuccess { JSON in
            
            let json = SwiftyJSON.JSON(JSON.dictionary["data"]!)
            
            if let array = json.array {
                for d in array {
                    
                    let id = d["id"].string
                    let username = d["username"].string
                    
                    if username == searchText {
                        
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.medialist.removeAll()
                            self.images.removeAll()
                            Shared.imageCache.removeAll()
                            self.collectionView.reloadData()
                           
                        })
                        
                        self.searchID = id!
                        
                        print(self.searchID)
                        
                   NSNotificationCenter.defaultCenter().postNotificationName("updateResult", object: nil)
                        
                        
                        
                        
                    }
                    else {
                        
                        self.searchID = ""
                    }
            }
            }
            
            
        }
        
    
    }
    
    
    
    func updateMediaWithSearchResult(){
        

        
        let accesstoken=NSUserDefaults.standardUserDefaults().objectForKey("IGAccessToken")!
        let stringURL="https://api.instagram.com/v1/users/\(searchID)/media/recent/?access_token=\(accesstoken)"
        let searchUsercache = Cache<Haneke.JSON>(name: "searchUser")
        searchUsercache.removeAll()
        let URL = NSURL(string: stringURL)!
        print(URL)
        
        searchUsercache.fetch(URL: URL).onSuccess { JSON in
            
            let json = SwiftyJSON.JSON(JSON.dictionary["data"]!)
            
            if let array = json.array {
                for d in array {
                    let media = Media(
                        
                        captions: d["caption"]["text"].string,
                        imageURL: d["images"]["standard_resolution"]["url"].URL)
                    
                    self.medialist.append(media)
                    print(media)
                    self.collectionView.reloadData()
                    
                    
                }
            }
            
            
            for i in self.medialist {
                
                let stringurl = i.imageURL!.absoluteString
                
                
                let photo = SKPhoto.photoWithImageURL(stringurl)
                photo.caption = i.captions
                self.images.append(photo)
                self.urlList.append(i.imageURL!)
                self.collectionView.reloadData()
                
                
                
                
            }
            
        }
        
            
        
        

    }
    
    
    


    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // user did type something, check our datasource for text that looks the same
        if searchText.characters.count > 0 {
            // search and reload data source
            self.searchBarActive    = true
            let search = searchText.lowercaseString
            self.searchUserID(search)
            
        }else{
            // if text lenght == 0
            // we will consider the searchbar is not active
            self.searchBarActive = false
            self.collectionView?.reloadData()
        }
        
    }
    
    // MARK: Configure SearchBar

    
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self .cancelSearching()
        self.collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        // we used here to set self.searchBarActive = YES
        // but we'll not do that any more... it made problems
        // it's better to set self.searchBarActive = YES when user typed something
        self.SearchBar!.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        // this method is being called when search btn in the keyboard tapped
        // we set searchBarActive = NO
        // but no need to reloadCollectionView
        self.searchBarActive = false
        self.SearchBar!.setShowsCancelButton(false, animated: false)
    }
    func cancelSearching(){
        self.searchBarActive = false
        self.SearchBar!.resignFirstResponder()
        self.SearchBar!.text = ""
    }
    
    
    func addObservers(){
        let context = UnsafeMutablePointer<UInt8>(bitPattern: 1)
        self.collectionView?.addObserver(self, forKeyPath: "contentOffset", options: [.New,.Old], context: context)
    }
    
    func removeObservers(){
        self.collectionView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    
    override func observeValueForKeyPath(keyPath: String?,
                                         ofObject object: AnyObject?,
                                                  change: [String : AnyObject]?,
                                                  context: UnsafeMutablePointer<Void>){
        if keyPath! == "contentOffset" {
            if let collectionV:UICollectionView = object as? UICollectionView {
                self.SearchBar?.frame = CGRectMake(
                    self.SearchBar!.frame.origin.x,
                    self.searchBarBoundsY! + ( (-1 * collectionV.contentOffset.y) - self.searchBarBoundsY!),
                    self.SearchBar!.frame.size.width,
                    self.SearchBar!.frame.size.height
                )
            }
        }
    }
        //MARK: Segue
        
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToLogin" {
            //get destination controller
            segue.destinationViewController as! ViewController
            
        }
    }
   
    
    
    func refreshcell(refreshControl: UIRefreshControl){
       
        
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            // stop refreshing after 2 seconds
            self.medialist.removeAll()
            self.images.removeAll()
            self.getMediaFromInstagram()
            refreshControl.endRefreshing()
        }
        
    }
    
    // MARK: 登出
    
    @IBAction func Logout(sender: AnyObject) {
        
        let alert = UIAlertController(title: "You have been Logout!", message: nil, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (_)in
            
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("IGAccessToken")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("UserName")
            
            // 清除webview 登入過的cookie
            if let cookies =   NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
                for cookie in cookies {
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
                }
            }
            
            self.performSegueWithIdentifier("unwindToLogin", sender: self)
        })
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
   
    
    
       
    // MARK: Get Data From Instagram API
    func getMediaFromInstagram(){
        
        
        let accesstoken=NSUserDefaults.standardUserDefaults().objectForKey("IGAccessToken")!
        let stringURL="https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accesstoken)"
        let cache = Cache<Haneke.JSON>(name: "instagram")
        cache.removeAll()
        let URL = NSURL(string: stringURL)!
        print(URL)
        
        cache.fetch(URL: URL).onSuccess { JSON in
         
            let json = SwiftyJSON.JSON(JSON.dictionary["data"]!)
            
            if let array = json.array {
                for d in array {
                    let media = Media(
                        
                        captions: d["caption"]["text"].string,
                        imageURL: d["images"]["standard_resolution"]["url"].URL)
                    
                    self.medialist.append(media)
                    self.collectionView.reloadData()
                    
                    
                }
            }
            
            
            for i in self.medialist {
                
                let stringurl = i.imageURL!.absoluteString
                
                
                let photo = SKPhoto.photoWithImageURL(stringurl)
                photo.caption = i.captions
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
       browser.displayToolbar = true
        // delete action(you must write `removePhoto` delegate, what resource you want to delete)
        // browser.displayDeleteButton = true
        
        // Optional action button titles (if left off, it uses activity controller
//         browser.actionButtonTitles = ["Save Image", "Do Another Action"]
        
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
