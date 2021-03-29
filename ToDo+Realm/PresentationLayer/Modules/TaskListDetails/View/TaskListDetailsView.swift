//
//  TaskListDetailsView.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 09/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit

final class TaskListDetailsView: UIView {
    
    let tasksList = UITableView(frame: .zero, style: .plain)

    // MARK: - Private properties

    private let disposeBag = DisposeBag()
    
    private let addButton = AddButton()
    private let emptyView = UIView()
    private let emptyTextLabel = UILabel()

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

    func bind(to viewModel: TaskListDetailsViewModelBindable) {
        // Bindings UI controls to view model's input/output
        viewModel.shouldShowEmptyView.drive(onNext: { [weak self] shouldShow in
            guard let self = self else { return }
            self.emptyView.isHidden = !shouldShow
            self.tasksList.isHidden = shouldShow
        }).disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.didTapAdd)
            .disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func setupViews() {
        tasksList.rowHeight = 70
        tasksList.tableFooterView = UIView()
        addSubview(tasksList)
        
        emptyView.backgroundColor = .purple
        addSubview(emptyView)
        
        emptyTextLabel.textColor = .white
        emptyTextLabel.numberOfLines = 0
        emptyTextLabel.lineBreakMode = .byWordWrapping
        emptyTextLabel.text = "You don't have any tasks yet. You can create a new one, just press a button with +"
        emptyView.addSubview(emptyTextLabel)
        
        addSubview(addButton)
    }
    
    private func setConstraints() {
        tasksList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyTextLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        addButton.snp.makeConstraints{ make in
            make.width.height.equalTo(50)
            make.trailing.bottom.equalToSuperview().offset(-24)
        }
    }
    
}
