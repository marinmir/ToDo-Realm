//
//  TaskDetailsCoordinator.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import InoMvvmc
import Swinject

final class TaskDetailsCoordinator: BaseCoordinator<Void> {
	// Replace <Void> with some other result type if necessary

	override func assemblies() -> [Assembly] {
		return [
			TaskDetailsModuleAssembly()
		]
	}

	override func start() {
		// Implement actual start from window/nav controller/tab bar controller here
	}
}
