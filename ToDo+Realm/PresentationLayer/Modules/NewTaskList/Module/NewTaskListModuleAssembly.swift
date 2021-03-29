//
//  NewTaskListModuleAssembly.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 03/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Swinject

final class NewTaskListModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NewTaskListViewModel.self) { resolver in
            // replace '_' with 'resolver' and inject dependencies if necessary
            let dbWriter = resolver.resolve(DatabaseWriter.self)!
            
            return NewTaskListViewModel(dbWriter: dbWriter)
        }

        container.register(NewTaskListModule.self) { resolver in
            let viewModel = resolver.resolve(NewTaskListViewModel.self)!
            let view = NewTaskListViewController(viewModel: viewModel)
            
            return NewTaskListModule(
                view: view,
                input: viewModel,
                output: viewModel
            )
        }
    }
}
