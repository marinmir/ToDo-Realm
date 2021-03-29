//
//  TaskDetailsModuleAssembly.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Swinject

final class TaskDetailsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TaskDetailsViewModel.self) { _ in
            // replace '_' with 'resolver' and inject dependencies if necessary
            return TaskDetailsViewModel()
        }

        container.register(TaskDetailsModule.self) { resolver in
            let viewModel = resolver.resolve(TaskDetailsViewModel.self)!
            let view = TaskDetailsViewController(viewModel: viewModel)
            
            return TaskDetailsModule(
                view: view,
                input: viewModel,
                output: viewModel
            )
        }
    }
}
