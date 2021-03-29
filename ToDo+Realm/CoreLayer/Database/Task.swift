//
//  Task.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 26.02.2021.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var deadline = Date()
    @objc dynamic var notes = ""
    @objc dynamic var isDone = false
    @objc dynamic var taskId = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "taskId"
    }
}
