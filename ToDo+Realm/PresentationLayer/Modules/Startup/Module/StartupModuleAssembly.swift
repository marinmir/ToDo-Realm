//
//  StartupModuleAssembly.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 28/02/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Swinject

final class StartupModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StartupViewModel.self) { _ in
            // replace '_' with 'resolver' and inject dependencies if necessary
            return StartupViewModel()
        }

        container.register(StartupModule.self) { resolver in
            let viewModel = resolver.resolve(StartupViewModel.self)!
            let view = StartupViewController(viewModel: viewModel)
            
            return StartupModule(
                view: view,
                input: viewModel,
                output: viewModel
            )
        }
    }
}
