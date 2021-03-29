//
//  DatabaseReaderImpl.swift
//  Backyard
//
//  Created by Evgenia Sleptsova on 17/07/2019.
//

import Foundation
import RealmSwift

class DatabaseReaderImpl: DatabaseReader {

    private var realm: Realm?

    init() {
        realm = try? Realm()
    }

    init(inMemoryIdentifier: String) {
        realm = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: inMemoryIdentifier))
    }

    func read<T: Object>() -> [T] {
        guard let objects = realm?.objects(T.self) else {
            return []
        }

        return Array(objects)
    }

    func read<T: Object>(sortedBy: String, ascending: Bool) -> [T] {
        guard let objects = realm?.objects(T.self).sorted(byKeyPath: sortedBy, ascending: ascending) else {
            return []
        }

        return Array(objects)
    }
    
    func read<T: Object>(filter: NSPredicate) -> [T] {
        guard let objects = realm?.objects(T.self).filter(filter) else {
            return []
        }

        return Array(objects)
    }
}
