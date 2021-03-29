//
//  TaskDetailsView.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class TaskDetailsView: UIView {

    // MARK: - Private properties

    private let disposeBag = DisposeBag()

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        setupViews()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func bind(to viewModel: TaskDetailsViewModelBindable) {
        // Bindings UI controls to view model's input/output
    }

    // MARK: - Private methods

    private func setupViews() {

    }

    private func setConstraints() {

    }
}
