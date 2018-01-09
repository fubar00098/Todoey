//
//  Item.swift
//  Todoey
//
//  Created by Spoke on 2018/1/7.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    //created relationships (to father)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
