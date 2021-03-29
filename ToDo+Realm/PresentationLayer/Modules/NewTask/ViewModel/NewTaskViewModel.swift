//
//  NewTaskViewModel.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// Describes view model's input streams/single methods
protocol NewTaskViewModelInput {
    var name: Binder<String> { get }
    var deadline: Binder<Date> { get }
    var notes: Binder<String> { get }
    var onTapCreateButton: Binder<Void> { get }
}

/// Describes view model's output streams needed to update UI
protocol NewTaskViewModelOutput {
    var canCreateTask: Driver<Bool> { get }
}

protocol NewTaskViewModelBindable: NewTaskViewModelInput & NewTaskViewModelOutput {}

final class NewTaskViewModel: NewTaskModuleInput & NewTaskModuleOutput {
    
    var onCreatedTask: ((Task) -> Void)?
    
    private let disposeBag = DisposeBag()
    
    private let nameRelay = BehaviorRelay<String>(value: "")
    private let deadlineRelay = BehaviorRelay<Date?>(value: nil)
    private let notesRelay = BehaviorRelay<String>(value: "")
    private let canCreateRelay = BehaviorRelay<Bool>(value: false)
    private let onTapCreateButtonRelay = PublishRelay<Void>()
    
    init() {
        Observable
            .combineLatest(
                nameRelay.asObservable(),
                deadlineRelay.asObservable())
            .subscribe(onNext: { [weak self] taskName, taskDeadline in
                guard let self = self else { return }
                self.canCreateRelay.accept(!(taskName.isEmpty || taskDeadline == nil))
            }).disposed(by: disposeBag)
        
        onTapCreateButtonRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.saveNewTask()
        }).disposed(by: disposeBag)
    }
    
    private func saveNewTask() {
        let newTask = Task()
        newTask.name = nameRelay.value
        newTask.createdAt = Date()
        newTask.isDone = false
        guard let deadline = deadlineRelay.value else { return }
        newTask.deadline = deadline
        newTask.notes = notesRelay.value
        
        onCreatedTask?(newTask)
    }
    
}

// MARK: - NewTaskViewModelBindable implementation

extension NewTaskViewModel: NewTaskViewModelBindable {
	// Describe all bindings here
    var name: Binder<String> {
        return Binder(nameRelay) { $0.accept($1) }
    }
    
    var deadline: Binder<Date> {
        return Binder(deadlineRelay) { $0.accept($1) }
    }
    
    var notes: Binder<String> {
        return Binder(notesRelay) { $0.accept($1) }
    }
    
    var canCreateTask: Driver<Bool> {
        return canCreateRelay.asDriver()
    }
    
    var onTapCreateButton: Binder<Void> {
        return Binder(onTapCreateButtonRelay) { $0.accept($1) }
    }
    
}
