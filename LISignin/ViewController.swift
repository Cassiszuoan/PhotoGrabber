//
//  ViewController.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlet Properties
    
   
    
    @IBOutlet weak var IGsignin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.loadList(_:)),name:"load", object: nil)
        
       
        checkForIGExistingAccessToken()
        
        
        
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadList(notification: NSNotification){
        //load data here
        self.viewDidLoad()
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

