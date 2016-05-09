//
//  IGViewController.swift
//  LISignIn
//
//  Created by JerryMAc on 2016/5/2.
// 
//

import UIKit
import Alamofire
import SwiftyJSON


class IGViewController: UIViewController,UIWebViewDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        startAuthorization()
        // Do any additional setup after loading the view.
        
        webView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAuthorization(){
        
       // 範例 https://api.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=code
        let authURL = AuthIG.Router.authURL
        let request = NSURLRequest(URL: authURL)
        webView.loadRequest(request)
        
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL!
        // request example : https://com.instagram.photograbber.oauth/oauth?code=546bb60e75cb460f9a534cb04f740817
        
        if url.host == "com.instagram.photograbber.oauth"{
            
            if url.absoluteString.rangeOfString("code") != nil {
                
                let urlParts = url.absoluteString.componentsSeparatedByString("?")
                let code = urlParts[1].componentsSeparatedByString("=")[1]
                print(code)
                requestForAccessToken(code)
                
            }
            
        }
        
        return true
        
    }
    
    func requestForAccessToken(authCode:String){
        
        let request = AuthIG.Router.requestAccessTokenURL(authCode)
        
       Alamofire
        .request(.POST, request.URLString , parameters:request.Params)
        .responseJSON{
            response in
            let json = JSON(response.result.value!)
            print(json)
            if  let accessToken = json["access_token"].string , userName = json["user"]["username"].string{
            
            
            NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "UserName")
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "IGAccessToken")
            NSUserDefaults.standardUserDefaults().synchronize()
            dispatch_async(dispatch_get_main_queue(), {()-> Void in
                
                
                
                self.performSegueWithIdentifier("loginsegue", sender: self)
            
            })
        }
            
        }
        
        

        
    }
    
    
    
    
    
    
    
    
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    

}
