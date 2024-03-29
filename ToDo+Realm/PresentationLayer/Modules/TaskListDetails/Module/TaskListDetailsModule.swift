//
//  TaskListDetailsModule.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 09/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import InoMvvmc

protocol TaskListDetailsModuleInput: AnyObject {
    func addNewTask(task: Task) 
}

protocol TaskListDetailsModuleOutput: AnyObject {
    var onTapAddButton: (() -> Void)? { get set }
}

final class TaskListDetailsModule: BaseModule<TaskListDetailsModuleInput, TaskListDetailsModuleOutput> {}
