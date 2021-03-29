//
//  ToDoListsCoordinator.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 01/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import InoMvvmc
import Swinject

final class ToDoListsCoordinator: BaseCoordinator<Void> {
	// Replace <Void> with some other result type if necessary

	override func assemblies() -> [Assembly] {
		return [
			ToDoListsModuleAssembly(),
            NewTaskListModuleAssembly()
		]
	}

	override func start() {
		// Implement actual start from window/nav controller/tab bar controller here
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let module = resolver.resolve(ToDoListsModule.self)!
            
            let navigationController = UINavigationController(rootViewController: module.view)
            
            module.output.onShowTaskList = { taskList in
                // 2 let taskListCoordinator = TaskListCoordinator(navigation: navigationController)
                // 2 self.coordinate(to: taskListCoordinator)
                
                let taskListDetailsCoordinator = TaskListDetailsCoordinator(taskList: taskList, navController: navigationController)
                
                taskListDetailsCoordinator.onComplete = { _ in
                    module.input.refresh()
                }
                
                self.coordinate(to: taskListDetailsCoordinator)
                
                // 1 let taskListModule = self.resolver.resolve(TaskListModule.self)!
                // 1 navigationController.pushViewController(taskListModule.view, animated: true)
            }
            
            module.output.onTapCreateButton = { [weak self] in
                self?.openNewTaskList(from: navigationController, for: module.input)
            }
            
            window.rootViewController = navigationController
        }
        
	}
    
    private func openNewTaskList(from viewController: UIViewController, for module: ToDoListsModuleInput) {
        let newTaskListModule = resolver.resolve(NewTaskListModule.self)!
        
        newTaskListModule.output.onCreatedList = {
            DispatchQueue.main.async {
                newTaskListModule.view.dismiss(animated: true, completion: nil)
                module.refresh()
            }
        }
        
        viewController.present(UINavigationController(rootViewController: newTaskListModule.view), animated: true, completion: nil)
    }
    
}
