//
//  TaskListDetailsViewModel.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 09/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// Describes view model's input streams/single methods
protocol TaskListDetailsViewModelInput {
    var didTapAdd: Binder<Void> { get }
    func deleteTask(task: Task)
    func didSelectDoneButton(isDone: Bool, for task: Task)
}

/// Describes view model's output streams needed to update UI
protocol TaskListDetailsViewModelOutput {
    var taskList: TaskList { get }
    var shouldShowEmptyView: Driver<Bool> { get }
    var tasks: Driver<[Task]> { get }
}

protocol TaskListDetailsViewModelBindable: TaskListDetailsViewModelInput & TaskListDetailsViewModelOutput {}

final class TaskListDetailsViewModel: TaskListDetailsModuleInput & TaskListDetailsModuleOutput {
    let taskList: TaskList
    var onTapAddButton: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    private let shouldShowEmptyViewRelay: BehaviorRelay<Bool>
    private let tasksRelay = BehaviorRelay<[Task]>(value: [])
    private let didTapAddRelay = PublishRelay<Void>()
    
    private let dbReader: DatabaseReader
    private let dbWriter: DatabaseWriter
    
    init(taskList: TaskList, dbReader: DatabaseReader, dbWriter: DatabaseWriter) {
        self.taskList = taskList
        self.dbReader = dbReader
        self.dbWriter = dbWriter
        
        shouldShowEmptyViewRelay = BehaviorRelay(value: taskList.tasks.isEmpty)
        tasksRelay.accept(Array(taskList.tasks))
        
        didTapAddRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.onTapAddButton?()
        }).disposed(by: disposeBag)
    }
    
    func didSelectDoneButton(isDone: Bool, for task: Task) {
        dbWriter.execute(for: task, with: task.taskId, block: { task in
            task.isDone = isDone
        }, completion: { [weak self] success in
            guard let self = self else { return }
            if success {
                self.refresh()
            }
        })
    }
    
    func addNewTask(task: Task) {
        dbWriter.execute(for: taskList, with: taskList.taskListId, block: { taskList in
            taskList.tasks.append(task)
        }, completion: { [weak self] success in
            guard let self = self else { return }
            if success {
                self.refresh()
            }
        })
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
            guard let self = self else { return }
            self.loadTasks()
        }
    }

    func loadTasks() {
        var tasks: [Task] = Array(self.taskList.tasks)
        tasks.sort { $0.createdAt < $1.createdAt }
        tasksRelay.accept(tasks)
        shouldShowEmptyViewRelay.accept(tasks.isEmpty)
    }

    func deleteTask (task: Task) {
        dbWriter.remove(item: task, completion: nil)
        refresh()
    }
    
}

// MARK: - TaskListDetailsViewModelBindable implementation

extension TaskListDetailsViewModel: TaskListDetailsViewModelBindable {
	// Describe all bindings here
    
    var shouldShowEmptyView: Driver<Bool> {
        return shouldShowEmptyViewRelay.asDriver().distinctUntilChanged()
    }
    
    var tasks: Driver<[Task]> {
        return tasksRelay.asDriver()
    }
    
    var didTapAdd: Binder<Void> {
        return Binder(didTapAddRelay) { $0.accept($1) }
    }
}
