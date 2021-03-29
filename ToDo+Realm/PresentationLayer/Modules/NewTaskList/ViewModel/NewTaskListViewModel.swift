//
//  NewTaskListViewModel.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 03/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// Describes view model's input streams/single methods
protocol NewTaskListViewModelInput {
    var onTapImage: Binder<Void> { get }
    var selectedImageName: Binder<String> { get }
    var selectedImage: Binder<UIImage> { get}
    var taskListNameInput: Binder<String> { get }
    var onTapCreateButton: Binder<Void> { get }
}

/// Describes view model's output streams needed to update UI
protocol NewTaskListViewModelOutput {
    var toDoListImage: Driver<UIImage> { get }
    var shouldShowAlertChooseImage: Signal<Void> { get }
    var canCreateTaskList: Driver<Bool> { get }
}

protocol NewTaskListViewModelBindable: NewTaskListViewModelInput & NewTaskListViewModelOutput {}

final class NewTaskListViewModel: NewTaskListModuleInput & NewTaskListModuleOutput {
    
     var onCreatedList: (() -> Void)?
    
    // MARK: - Private properties
    
    private let disposeBag = DisposeBag()
    private let dbWriter: DatabaseWriter
    
    private let toDoListImageRelay = BehaviorRelay<UIImage>(value: UIImage(named: "defaultImage") ?? UIImage())
    private let onTapImageRelay = PublishRelay<Void>()
    private let selectedImageNameRelay = BehaviorRelay<String>(value: "")
    private let canCreateTaskListRelay = BehaviorRelay<Bool>(value: false)
    private let taskListNameInputRelay = BehaviorRelay<String>(value: "")
    private let onTapCreateButtonRelay = PublishRelay<Void>()
    
    init(dbWriter: DatabaseWriter) {
        self.dbWriter = dbWriter
        
        Observable
            .combineLatest(
                taskListNameInputRelay.asObservable(),
                selectedImageNameRelay.asObservable())
            .subscribe(onNext: { taskListName, taskListImageName in
                self.canCreateTaskListRelay.accept(!(taskListName.isEmpty || taskListImageName.isEmpty))
            }).disposed(by: disposeBag)
        
        onTapCreateButtonRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.saveImageLocally()
            
            let newTaskList = TaskList()
            newTaskList.name = self.taskListNameInputRelay.value
            newTaskList.imageURL = self.selectedImageNameRelay.value
            self.dbWriter.write(items: [newTaskList]) { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.onCreatedList?()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func saveImageLocally() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(selectedImageNameRelay.value)
    
        if let data = toDoListImageRelay.value.jpegData(compressionQuality:  1.0),
          !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
}

// MARK: - NewTaskListViewModelBindable implementation

extension NewTaskListViewModel: NewTaskListViewModelBindable {
	// Describe all bindings here
    var toDoListImage: Driver<UIImage> {
        toDoListImageRelay.asDriver()
    }
    
    var onTapImage: Binder<Void> {
        return Binder(onTapImageRelay) { $0.accept($1) }
    }
    
    var taskListNameInput: Binder<String> {
        return Binder(taskListNameInputRelay) { $0.accept($1) }
    }
    
    var shouldShowAlertChooseImage: Signal<Void> {
        return onTapImageRelay.asSignal()
    }
    
    var selectedImageName: Binder<String> {
        return Binder(selectedImageNameRelay) { $0.accept($1) }
    }
    
    var selectedImage: Binder<UIImage> {
        return Binder(toDoListImageRelay) { $0.accept($1) }
    }
    
    var canCreateTaskList: Driver<Bool> {
        return canCreateTaskListRelay.asDriver()
    }
    
    var onTapCreateButton: Binder<Void> {
        return Binder(onTapCreateButtonRelay) { $0.accept($1) }
    }
    
}
