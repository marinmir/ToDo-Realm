//
//  DatabaseWriterImpl.swift
//  Backyard
//
//  Created by Evgenia Sleptsova on 17/07/2019.
//

import Foundation
import RealmSwift

class DatabaseWriterImpl: DatabaseWriter {

    private var realm: Realm?
    private let worker: ThreadWorker!

    init(inMemoryIdentifier: String? = nil) {
        worker = ThreadWorker()
        worker.enqueue { [weak self] in
            guard let self = self else {
                return
            }
            if let inMemoryIdentifier = inMemoryIdentifier {
                self.realm = try? Realm(configuration: Realm.Configuration(inMemoryIdentifier: inMemoryIdentifier))
            } else {
                self.realm = try? Realm()
            }
        }
    }

    func execute<T, KeyType>(
        for object: T,
        with key: KeyType,
        block: @escaping (T) -> Void,
        completion: ((Bool) -> Void)?
    ) where T : Object {
        worker.enqueue { [weak self] in
            guard let realm = self?.realm else {
                return
            }
            var isSuccess = true
            do {
                try realm.write {
                    if let obj = realm.object(ofType: T.self, forPrimaryKey: key) {
                        block(obj)
                    } else {
                        isSuccess = false
                    }
                }
            }
            catch {
                isSuccess = false
            }
            completion?(isSuccess)
        }
    }
    
    func update<T: Object>(_ obj: T, completion: ((Bool) -> Void)?) {
        let tsr = ThreadSafeReference(to: obj)
        worker.enqueue { [weak self] in
            var isSuccess = true
            guard let realm = self?.realm else {
                completion?(false)
                return
            }
            do {
                try realm.write {
                    guard let sourceObj = realm.resolve(tsr) else { return }
                    realm.add(sourceObj, update: .modified)
                }
            } catch {
                isSuccess = false
            }
            completion?(isSuccess)
        }
    }
    
    func write<T: Object>(items: [T], completion: ((_ success: Bool) -> Void)?) {
        worker.enqueue { [weak self] in
            guard let self = self else { return }
            var isSuccess = true
            for item in items {
                do {
                    try self.realm?.write {
                        self.realm?.add(item)
                    }
                } catch {
                    isSuccess = false
                }
                if !isSuccess {
                    break
                }
            }
            
            completion?(isSuccess)
        }
    }
    
    func remove<T: Object>(item: T, completion: ((_ success: Bool) -> Void)?) {
        let tsr = ThreadSafeReference(to: item)
        worker.enqueue { [weak self] in
            var isSuccess = true
            do {
                try self?.realm?.write {
                    guard let obj = self?.realm?.resolve(tsr) else { return }
                    self?.realm?.delete(obj)
                }
            } catch {
                isSuccess = false
            }
            completion?(isSuccess)
        }
    }
    
    func remove<T: Object>(items: [T], completion: ((_ success: Bool) -> Void)?) {
        worker.enqueue { [weak self] in
            var isSuccess = true
            do {
                try self?.realm?.write {
                    self?.realm?.delete(items)
                }
            } catch {
                isSuccess = false
            }
            completion?(isSuccess)
        }
    }

    func removeAllObjects<T: Object>(of type: T.Type, completion: ((_ success: Bool) -> Void)?) {
        worker.enqueue { [weak self] in
            var isSuccess = true
            do {
                guard let objects = self?.realm?.objects(type) else {
                    return
                }
                try self?.realm?.write {
                    self?.realm?.delete(objects)
                }
            } catch {
                isSuccess = false
            }
            completion?(isSuccess)
        }
    }
}
