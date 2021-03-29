//
//  NewTaskModule.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import InoMvvmc

protocol NewTaskModuleInput: AnyObject {}

protocol NewTaskModuleOutput: AnyObject {
    var onCreatedTask: ((Task) -> Void)? { get set }
}

final class NewTaskModule: BaseModule<NewTaskModuleInput, NewTaskModuleOutput> {}
