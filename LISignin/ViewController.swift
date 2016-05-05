//
//  ViewController.swift
// 
//
//
//

import UIKit
import Alamofire
import SwiftyJSON
import SKPhotoBrowser
class ViewController: UIViewController {

    // MARK: IBOutlet Properties
    
   
    
    @IBOutlet weak var IGsignin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.loadList(_:)),name:"load", object: nil)
        
       
        checkForIGExistingAccessToken()
        
        print(NSUserDefaults.standardUserDefaults().objectForKey("IGAccessToken"))
        
        
       
        
        
    }

    @IBAction func getUserInfo(sender: AnyObject) {
        
        let accesstoken = String(NSUserDefaults.standardUserDefaults().objectForKey("IGAccessToken")!)
        
        var url = "https://api.instagram.com/v1/users/self/?access_token="
        url+=accesstoken
        
        print(url)
        
        Alamofire.request(.GET, url).responseJSON{
            response in
            let json = JSON(response.result.value!)
            print(json)
        }
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadList(notification: NSNotification){
        //load data here
        self.viewDidLoad()
    }
    
    
    
    @IBAction func showPhotoBrowser(sender: AnyObject) {
        
    }
    
    @IBAction func Logout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("IGAccessToken")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("UserName")
        
        // 清除webview 登入過的cookie
        if let cookies =   NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
        checkForIGExistingAccessToken()
        
        
        
    }
    
    
    func checkForIGExistingAccessToken(){
        if NSUserDefaults.standardUserDefaults().objectForKey("IGAccessToken") == nil{
            IGsignin.enabled = true
        }
        else{
            
            IGsignin.enabled = false
        }
    }
    
        // MARK: IBAction Functions

    @IBAction func getProfileInfo(sender: AnyObject) {
        
        
        
    }
    
    
    @IBAction func openProfileInSafari(sender: AnyObject) {
       
        
       
    }
    
    
    
}

extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}

