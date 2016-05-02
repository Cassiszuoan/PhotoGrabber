//
//  IGViewController.swift
//  LISignIn
//
//  Created by JerryMAc on 2016/5/2.
//  Copyright © 2016年 Appcoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class IGViewController: UIViewController,UIWebViewDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    
    let IgKey = "22153ebbc4a0490199e5f7aa5ed9f53d"
    let IgSecret = "5e1345ea144e4226b21a49959dfe6622"
    let authEndPoint = "https://api.instagram.com/oauth/authorize/"
    let accessTokenEndPoint = "https://api.instagram.com/oauth/access_token"
    
    

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
        
        
        
        let client_id = IgKey
        let redirect_uri="https://com.instagram.photograbber.oauth/oauth"
        let response_type="code"
        
        var authURL = "\(authEndPoint)?"
        authURL += "client_id=\(client_id)&"
        authURL += "redirect_uri=\(redirect_uri)&"
        authURL += "response_type=\(response_type)"
        
        let request = NSURLRequest(URL: NSURL(string: authURL)!)
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
        
        
        let grantType = "authorization_code"
        let redirectURL = "https://com.instagram.photograbber.oauth/oauth"
        let parameters = [
            
            "grant_type": grantType,
            "code": authCode,
            "redirect_uri":redirectURL,
            "client_id":IgKey,
            "client_secret":IgSecret,
            
        ]
        
       Alamofire
        .request(.POST, accessTokenEndPoint, parameters: parameters)
        .responseJSON{
            response in
            let json = JSON(response.result.value!)
            let accessToken = json["access_token"].stringValue
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "IGAccessToken")
            NSUserDefaults.standardUserDefaults().synchronize()
            dispatch_async(dispatch_get_main_queue(), {()-> Void in
                self.dismissViewControllerAnimated(true){
                    ()-> Void in

            NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                    
                }
            
            })
        }
        
        

        
    }
    
    
    
    
    
    
    
    
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    

}
