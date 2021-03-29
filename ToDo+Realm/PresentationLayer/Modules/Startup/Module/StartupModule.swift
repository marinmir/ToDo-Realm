//
//  StartupModule.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 28/02/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import InoMvvmc

enum StartupResult {
    case success
    case error
}

protocol StartupModuleInput: AnyObject {}

protocol StartupModuleOutput: AnyObject {
    var onComplete: ((StartupResult) -> Void)? { get set }
}

final class StartupModule: BaseModule<StartupModuleInput, StartupModuleOutput> {}
