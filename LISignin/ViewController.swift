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
        
        print(NSUserDefaults.standardUserDefaults().objectForKey("IGAccessToken"))
        
        if NSUserDefaults.standardUserDefaults().objectForKey("IGAccessToken") != nil {
            
            
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.performSegueWithIdentifier("showPhotoBrowser", sender: self)
            }
            
            
        }
        
  
    }
    

        
        
        
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
   
    
    
}



