//
//  TaskListDetailsViewController.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 09/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TaskListDetailsViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: TaskListDetailsViewModelBindable
    
    private var tasks: [Task] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers

    init(viewModel: TaskListDetailsViewModelBindable) {
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

        let view = TaskListDetailsView()
        view.bind(to: viewModel)

        self.view = view
        setTasksTableView()
        
        viewModel.tasks.drive(onNext: { [weak self] tasks in
            guard let self = self else { return }
            self.tasks = tasks
            guard let view = self.view as? TaskListDetailsView else { return }
            view.tasksList.reloadData()
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.taskList.name
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private methods
    
    private func setTasksTableView() {
        guard let view = view as? TaskListDetailsView else {
            return
        }
        
        view.tasksList.delegate = self
        view.tasksList.dataSource = self
        view.tasksList.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifer)
    }
}

// MARK: - UITableViewDelegate

extension TaskListDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //viewModel.didSelectRow.onNext(indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension TaskListDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifer, for: indexPath)
        
        guard let resultCell = cell as? TaskCell else {
            return cell
        }
        
        resultCell.configure(task: tasks[indexPath.row])
        
        resultCell.didSelectDone = { [weak self] isDone in
            guard let self = self else { return }
            let task = self.tasks[indexPath.row]
            self.viewModel.didSelectDoneButton(isDone: isDone, for: task)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(task: tasks[indexPath.row])
        }
    }
}
