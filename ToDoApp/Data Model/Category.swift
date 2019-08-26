//
//  Category.swift
//  ToDoApp
//
//  Created by Natalija Mitic on 26.08.19.
//  Copyright © 2019 Natalija Mitic. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var colorHex: String = ""
    let items = List<Item>()
    
}
