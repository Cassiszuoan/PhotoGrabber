//
//  User.swift
//  PhotoGrabber
//
//  Created by JerryMAc on 2016/5/4.
//  Copyright © 2016年 Appcoda. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject{
    
    @NSManaged var userID: String
    @NSManaged var accessToken: String
    
}