//
//  Category.swift
//  Todoey
//
//  Created by Tommy Nguyen on 7/13/18.
//  Copyright © 2018 Tommy Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
