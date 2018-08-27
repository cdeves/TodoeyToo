//
//  Category.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/24/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    //create a new Realm property using keywords: @objc dynamic, to allow Realm to monitor these properties for change in real time
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    //List is a Realm object that's equivalent to an array
    let items = List<Item>() //defines a FORWARD relationship to the Item object class
}
