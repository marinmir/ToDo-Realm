//
//  TaskListDetailsCoordinator.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 09/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import InoMvvmc
import Swinject

final class TaskListDetailsCoordinator: BaseCoordinator<Void> {
	// Replace <Void> with some other result type if necessary
    private let taskList: TaskList
    private let navigationViewController: UINavigationController
    
    init(taskList: TaskList, navController: UINavigationController) {
        self.taskList = taskList
        navigationViewController = navController
        super.init()
    }
    
	override func assemblies() -> [Assembly] {
		return [
			TaskListDetailsModuleAssembly(),
            NewTaskModuleAssembly()
		]
	}

	override func start() {
		// Implement actual start from window/nav controller/tab bar controller here
        let module = resolver.resolve(TaskListDetailsModule.self, argument: taskList)!
        navigationViewController.pushViewController(module.view, animated: true)
        
        module.output.onTapAddButton = { [weak self] in
            guard let self = self else { return }
            self.openNewTask(from: self.navigationViewController, with: module)
        }
	}
    
    private func openNewTask(from viewController: UIViewController, with parent: TaskListDetailsModule) {
        let newTaskModule = resolver.resolve(NewTaskModule.self)!
        
        newTaskModule.output.onCreatedTask = { task in
            parent.input.addNewTask(task: task)
            newTaskModule.view.dismiss(animated: true, completion: nil)
            
        }
        
        viewController.present(UINavigationController(rootViewController: newTaskModule.view), animated: true, completion: nil)
    }
    
}
