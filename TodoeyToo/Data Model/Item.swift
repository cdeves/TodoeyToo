//
//  Item.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/22/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import Foundation

//to write this data to a file path, it must conform to Encodable & Decodable protocols (that is, they are Codable and contain only standard data types)
class Item: Codable {
    
    var title: String = ""
    var done: Bool = false
    
}
