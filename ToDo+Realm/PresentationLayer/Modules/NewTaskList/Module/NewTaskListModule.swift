//
//  NewTaskListModule.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 03/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import InoMvvmc

protocol NewTaskListModuleInput: AnyObject {}

protocol NewTaskListModuleOutput: AnyObject {
    var onCreatedList: (() -> Void)? { get set }
}

final class NewTaskListModule: BaseModule<NewTaskListModuleInput, NewTaskListModuleOutput> {}
