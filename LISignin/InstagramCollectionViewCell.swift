//
//  InstagramCollectionViewCell.swift
//  PhotoGrabber
//
//  Created by JerryMAc on 2016/5/5.
//  Copyright © 2016年 Jerry Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class InstagramCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blackColor().CGColor
        
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
