//
//  Item.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/24/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //define the reverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //each Item has a parentCategory of type Category that comes from Category's property "items"

}
