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
        
        Logout()
        
  
    }
    

        
        
        
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
   
    
    
    
     func Logout() {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("IGAccessToken")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("UserName")
        
        // 清除webview 登入過的cookie
        if let cookies =   NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
        
        
    }
    
    


    
    
    
    
    
    
    
}



