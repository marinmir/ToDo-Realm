//
//  TaskDetailsViewController.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import UIKit

final class TaskDetailsViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: TaskDetailsViewModelBindable

    // MARK: - Initializers

    init(viewModel: TaskDetailsViewModelBindable) {
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

        let view = TaskDetailsView()
        view.bind(to: viewModel)

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
