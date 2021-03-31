//
//  DatabaseWriter.swift
//  Backyard
//
//  Created by Evgenia Sleptsova on 17/07/2019.
//

import Foundation
import RealmSwift

protocol DatabaseWriter {

    func execute<T: Object, KeyType>(for object: T, with key: KeyType, block: @escaping (T) -> Void, completion: ((_ success: Bool) -> Void)?)
    
    func update<T: Object>(_ obj: T, completion: ((_ success: Bool) -> Void)?)
    
    func write<T: Object>(items: [T], completion: ((_ success: Bool) -> Void)?)
    
    func remove<T: Object>(item: T, completion: ((_ success: Bool) -> Void)?)

    func removeAllObjects<T: Object>(of type: T.Type, completion: ((_ success: Bool) -> Void)?)
    
    func remove<T: Object>(items: [T], completion: ((_ success: Bool) -> Void)?)
}

extension DatabaseWriter {

    func execute<T: Object, KeyType>(for object: T, with key: KeyType, block: @escaping (T) -> Void, completion: ((_ success: Bool) -> Void)? = nil) {
        execute(for: object, with: key, block: block, completion: completion)
    }
    
    func update<T: Object>(_ obj: T, completion: ((_ success: Bool) -> Void)? = nil) {
        update(obj, completion: completion)
    }
    
    func write<T: Object>(items: [T], completion: ((_ success: Bool) -> Void)? = nil) {
        write(items: items, completion: completion)
    }
    
    func remove<T: Object>(item: T, completion: ((_ success: Bool) -> Void)? = nil) {
        remove(item: item, completion: completion)
    }
    
    func remove<T: Object>(items: [T], completion: ((_ success: Bool) -> Void)? = nil) {
        remove(items: items, completion: completion)
    }

    func removeAllObjects<T: Object>(of type: T.Type, completion: ((_ success: Bool) -> Void)? = nil) {
        removeAllObjects(of: type, completion: completion)
    }
}
