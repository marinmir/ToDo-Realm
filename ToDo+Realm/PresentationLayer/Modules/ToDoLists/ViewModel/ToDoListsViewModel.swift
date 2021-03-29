//
//  ToDoListsViewModel.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 01/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// Describes view model's input streams/single methods
protocol ToDoListsViewModelInput {
    var didSelectRow: Binder<Int> { get }
    var didTapCreate: Binder<Void> { get }
    
    func loadToDoTasks()
    func deleteTaskList(list: TaskList)
    
}

/// Describes view model's output streams needed to update UI
protocol ToDoListsViewModelOutput {
    var toDoLists: Driver<[TaskList]> { get }
    var shouldShowEmptyView: Driver<Bool> { get }
}

protocol ToDoListsViewModelBindable: ToDoListsViewModelInput & ToDoListsViewModelOutput {}

final class ToDoListsViewModel: ToDoListsModuleInput & ToDoListsModuleOutput  {
    var onShowTaskList: ((TaskList) -> Void)?
    var onTapCreateButton: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    private let selectedRowRelay = PublishRelay<Int>()
    private let toDoListsRelay = BehaviorRelay<[TaskList]>(value: [])
    private let tappedCreateButton = PublishRelay<Void>()
    
    private let dbReader: DatabaseReader
    private let dbWriter: DatabaseWriter
    
    init(dbReader: DatabaseReader, dbWriter: DatabaseWriter) {
        self.dbReader = dbReader
        self.dbWriter = dbWriter
        
        selectedRowRelay
            .subscribe(onNext: { [weak self] selectedIndex in
                guard let self = self else { return }
                self.onShowTaskList?(self.toDoListsRelay.value[selectedIndex])
            }).disposed(by: disposeBag)
        
        tappedCreateButton
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.onTapCreateButton?()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
            guard let self = self else { return }
            self.loadToDoTasks()
        }
    }
    
    func loadToDoTasks() {
        var lists: [TaskList] = dbReader.read()
        lists.sort { $0.tasks.count > $1.tasks.count }
        toDoListsRelay.accept(lists)
    }
    
    func deleteTaskList(list: TaskList) {
        dbWriter.remove(item: list, completion: nil)
        refresh()
    }
    
}

// MARK: - ToDoListsViewModelBindable implementation

extension ToDoListsViewModel: ToDoListsViewModelBindable {
    var didSelectRow: Binder<Int> {
        return Binder(selectedRowRelay) { $0.accept($1) }
    }
    
    var toDoLists: Driver<[TaskList]> {
        return toDoListsRelay.asDriver()
    }
    
    var shouldShowEmptyView: Driver<Bool> {
        return toDoListsRelay.map { $0.isEmpty }.asDriver(onErrorJustReturn: true)
    }
    
    var didTapCreate: Binder<Void> {
        return Binder(tappedCreateButton) { $0.accept($1) }
    }
}

