//
//  ToDoListsModule.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 01/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import InoMvvmc

protocol ToDoListsModuleInput: AnyObject {
    func refresh()
}

protocol ToDoListsModuleOutput: AnyObject {
    var onShowTaskList: ((TaskList) -> Void)? { get set }
    var onTapCreateButton: (() -> Void)? { get set }
}

final class ToDoListsModule: BaseModule<ToDoListsModuleInput, ToDoListsModuleOutput> {}
