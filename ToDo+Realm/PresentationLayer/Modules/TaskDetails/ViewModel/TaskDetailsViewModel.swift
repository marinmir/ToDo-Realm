//
//  TaskDetailsViewModel.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// Describes view model's input streams/single methods
protocol TaskDetailsViewModelInput {}

/// Describes view model's output streams needed to update UI
protocol TaskDetailsViewModelOutput {}

protocol TaskDetailsViewModelBindable: TaskDetailsViewModelInput & TaskDetailsViewModelOutput {}

final class TaskDetailsViewModel: TaskDetailsModuleInput & TaskDetailsModuleOutput {
    private let disposeBag = DisposeBag()
}

// MARK: - TaskDetailsViewModelBindable implementation

extension TaskDetailsViewModel: TaskDetailsViewModelBindable {
	// Describe all bindings here
}
