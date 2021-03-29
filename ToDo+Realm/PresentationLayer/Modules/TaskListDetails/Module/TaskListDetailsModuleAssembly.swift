//
//  TaskListDetailsModuleAssembly.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 09/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Swinject

final class TaskListDetailsModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(TaskListDetailsModule.self) { (resolver, taskList: TaskList) in
            let dbReader = resolver.resolve(DatabaseReader.self)!
            let dbWriter = resolver.resolve(DatabaseWriter.self)!
            
            let viewModel = TaskListDetailsViewModel(taskList: taskList,
                                                     dbReader: dbReader,
                                                     dbWriter: dbWriter)
            let view = TaskListDetailsViewController(viewModel: viewModel)
            
            return TaskListDetailsModule(
                view: view,
                input: viewModel,
                output: viewModel
            )
        }
    }
}
