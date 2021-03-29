//
//  StartupViewController.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 28/02/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import UIKit

final class StartupViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: StartupViewModelBindable

    // MARK: - Initializers

    init(viewModel: StartupViewModelBindable) {
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

        let view = StartupView()
        view.bind(to: viewModel)

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startup()
    }
}
