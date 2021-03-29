//
//  NewTaskModuleAssembly.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Swinject

final class NewTaskModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NewTaskViewModel.self) { _ in
            // replace '_' with 'resolver' and inject dependencies if necessary
            return NewTaskViewModel()
        }

        container.register(NewTaskModule.self) { resolver in
            let viewModel = resolver.resolve(NewTaskViewModel.self)!
            let view = NewTaskViewController(viewModel: viewModel)
            
            return NewTaskModule(
                view: view,
                input: viewModel,
                output: viewModel
            )
        }
    }
}
