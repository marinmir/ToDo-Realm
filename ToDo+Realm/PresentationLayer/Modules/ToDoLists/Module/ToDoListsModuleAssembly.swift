//
//  ToDoListsModuleAssembly.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 01/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Swinject

final class ToDoListsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ToDoListsViewModel.self) { resolver in
            let dbReader = resolver.resolve(DatabaseReader.self)!
            let dbWriter = resolver.resolve(DatabaseWriter.self)!
            
            return ToDoListsViewModel(dbReader: dbReader, dbWriter: dbWriter)
        }

        container.register(ToDoListsModule.self) { resolver in
            let viewModel = resolver.resolve(ToDoListsViewModel.self)!
            let view = ToDoListsViewController(viewModel: viewModel)
            
            return ToDoListsModule(
                view: view,
                input: viewModel,
                output: viewModel
            )
        }
    }
}
