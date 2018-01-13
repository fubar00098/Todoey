//
//  Category.swift
//  Todoey
//
//  Created by Spoke on 2018/1/7.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import Foundation
import RealmSwift

//we able to save our data using realm 
class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor : String = ""
    
    //created relationships (to-many)
    let items = List<Item>()
    
}
