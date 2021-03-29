//
//  ToDoListsViewController.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 01/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ToDoListsViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: ToDoListsViewModelBindable
    private let disposeBag = DisposeBag()
    
    private var toDoLists: [TaskList] = []

    // MARK: - Initializers

    init(viewModel: ToDoListsViewModelBindable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    override func loadView() {
        super.loadView()

        let view = ToDoListsView()
        view.bind(to: viewModel)

        self.view = view
        setToDoListsTableView()
        
        viewModel.toDoLists.drive(onNext: { [weak self] toDoLists in
            guard let self = self else { return }
            self.toDoLists = toDoLists
            guard let view = self.view as? ToDoListsView else {
                return
            }
            view.toDoListsTableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDoTasks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadToDoTasks()
    }
    
    // MARK: - Private methods
    
    private func setToDoListsTableView() {
        guard let view = view as? ToDoListsView else {
            return
        }
        
        view.toDoListsTableView.delegate = self
        view.toDoListsTableView.dataSource = self
        view.toDoListsTableView.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseIdentifer)
    }
}

// MARK: - UITableViewDelegate

extension ToDoListsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow.onNext(indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension ToDoListsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseIdentifer, for: indexPath)
        
        guard let resultCell = cell as? TaskListCell else {
            return cell
        }
        
        resultCell.configure(toDoList: toDoLists[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTaskList(list: toDoLists[indexPath.row])
        }
    }
}
