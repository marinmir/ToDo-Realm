//
//  TaskDetailsModule.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import InoMvvmc

protocol TaskDetailsModuleInput: AnyObject {}

protocol TaskDetailsModuleOutput: AnyObject {}

final class TaskDetailsModule: BaseModule<TaskDetailsModuleInput, TaskDetailsModuleOutput> {}
