//
//  Auth.swift
//  PhotoGrabber
//
//  Created by JerryMAc on 2016/5/4.


import Foundation
import Alamofire

let IG_CLIENT_KEY = "22153ebbc4a0490199e5f7aa5ed9f53d"
let IG_CLIENT_SECRET = "5e1345ea144e4226b21a49959dfe6622"
let IG_REDIRECT_URL = "https://com.instagram.photograbber.oauth/oauth"


struct AuthIG {
    
    enum Router: URLRequestConvertible{
        static let baseURLString = "https://api.instagram.com"
        static let clientID = IG_CLIENT_KEY
        static let clientSecret = IG_CLIENT_SECRET
        static let redirectURL = IG_REDIRECT_URL
        static let authURL = NSURL(string:Router.baseURLString+"/oauth/authorize/?client_id="+Router.clientID+"&redirect_uri="+Router.redirectURL+"&response_type=code")!
        
        
        case requestCode
        
        
        static func  requestAccessTokenURL(code:String) -> (URLString:String,Params:[String:AnyObject]){
            let params = ["client_id":Router.clientID , "client_secret": Router.clientSecret,"grant_type":"authorization_code","redirect_uri":Router.redirectURL,"code":code]
            let path = "/oauth/access_token"
            let urlString = AuthIG.Router.baseURLString+path
            return (urlString,params)
        }
        
        
        
        var URLRequest: NSMutableURLRequest{
            
            let (path,parameters): (String,[String:AnyObject]?) = {
                switch self{
                case .requestCode:
                    let pathString = "/oauth/authorize/?client_id+"+Router.clientID + "&redirect_uri="+Router.redirectURL + "&response_type=code"
                    return (pathString,nil)
                }
            }()
            
            let BaseURL = NSURL(string:Router.baseURLString)
            let URLRequest = NSURLRequest(URL: BaseURL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            return encoding.encode(URLRequest, parameters: parameters).0
            
        }
       
    }
    
    
    
   
    
}


