//
//  TaskList.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 26.02.2021.
//

import Foundation
import RealmSwift

class TaskList: Object {
    @objc dynamic var name = ""
    let tasks = List<Task>()
    @objc dynamic var imageURL = ""
    @objc dynamic var taskListId = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "taskListId"
    }
}

extension TaskList {
    
    var image: UIImage {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageURL)
        var image = UIImage(named: "defaultImage") ?? UIImage()
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            image = UIImage(contentsOfFile: fileURL.path) ?? UIImage()
        } else {
            //do nothing
        }
        
        return image
    }
    
}
