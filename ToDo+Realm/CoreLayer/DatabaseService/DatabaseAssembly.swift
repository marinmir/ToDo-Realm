//
//  DatabaseAssembly.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 03.03.2021.
//

import Foundation
import Swinject

final class DatabaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DatabaseReader.self) { _ in
            return DatabaseReaderImpl()
        }
        
        container.register(DatabaseReader.self) { (_, inMemoryIdentifier: String) in
            return DatabaseReaderImpl(inMemoryIdentifier: inMemoryIdentifier)
        }
        
        container.register(DatabaseWriter.self) { _ in
            return DatabaseWriterImpl()
        }
        
        container.register(DatabaseWriter.self) { (_, inMemoryIdentifier: String) in
            return DatabaseWriterImpl(inMemoryIdentifier: inMemoryIdentifier)
        }
    }
}
