//
//  ToDoListsView.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 01/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import RxSwift
import UIKit
import SnapKit

final class ToDoListsView: UIView {
    
    let toDoListsTableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Private properties

    private let disposeBag = DisposeBag()
    
    private let emptyView = UIView()
    private let emptyTextLabel = UILabel()
    
    private let createButton = AddButton()
    
    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        setViews()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func bind(to viewModel: ToDoListsViewModelBindable) {
        // Bindings UI controls to view model's input/output
        viewModel.shouldShowEmptyView.drive(onNext: { [weak self] shouldShow in
            guard let self = self else { return }
            self.toDoListsTableView.isHidden = shouldShow
            self.emptyView.isHidden = !shouldShow
        }).disposed(by: disposeBag)
        
        createButton.rx.tap
            .bind(to: viewModel.didTapCreate)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setViews() {
        toDoListsTableView.rowHeight = 100
        toDoListsTableView.tableFooterView = UIView()
        addSubview(toDoListsTableView)
        
        emptyView.backgroundColor = .white
        addSubview(emptyView)
        
        emptyTextLabel.textColor = .systemBlue
        emptyTextLabel.numberOfLines = 0
        emptyTextLabel.lineBreakMode = .byWordWrapping
        emptyTextLabel.text = "You don't have any ToDo Lists yet. You can create a new one, just press a button below"
        emptyView.addSubview(emptyTextLabel)
        
        addSubview(createButton)
    }
    
    private func setConstraints() {
        toDoListsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        emptyTextLabel.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        createButton.snp.makeConstraints{ make in
            make.width.height.equalTo(50)
            make.trailing.bottom.equalToSuperview().offset(-24)
        }
    }
}
