//
//  StartupCoordinator.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 28/02/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import InoMvvmc
import Swinject

final class StartupCoordinator: BaseCoordinator<Void> {
	// Replace <Void> with some other result type if necessary

	override func assemblies() -> [Assembly] {
		return [
			StartupModuleAssembly()
		]
	}

	override func start() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let module = resolver.resolve(StartupModule.self)!
            
            module.output.onComplete = { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success:
                    let todoListsCoordinator = ToDoListsCoordinator()
                    self.coordinate(to: todoListsCoordinator)
                case .error:
                    self.showErrorAlert(with: module.view)
                }
            }
            
            window.rootViewController = module.view
        }
	}
    
    private func showErrorAlert(with viewController: UIViewController) {
        let alert = UIAlertController(title: "UUUPS", message: "Something went wrong", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
