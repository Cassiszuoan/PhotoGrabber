//
//  InstagramCollectionViewCell.swift
//  PhotoGrabber
//
//  Created by JerryMAc on 2016/5/5.
//  Copyright © 2016年 Jerry Lee. All rights reserved.
//

import UIKit

class InstagramCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
