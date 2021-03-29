//
//  NewTaskListView.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 03/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit

final class NewTaskListView: UIView {

    // MARK: - Private properties

    private let disposeBag = DisposeBag()
    
    private let imageView = UIImageView()
    private let nameTextField = UITextField()
    private let createButton = CustomButton()

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

    func bind(to viewModel: NewTaskListViewModelBindable) {
        // Bindings UI controls to view model's input/output
        viewModel.toDoListImage
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
        
        let imageViewTap = UITapGestureRecognizer()
        imageView.addGestureRecognizer(imageViewTap)
        imageViewTap.rx.event
            .map { _ in return }
            .bind(to: viewModel.onTapImage)
            .disposed(by: disposeBag)
        
        viewModel.canCreateTaskList.drive(createButton.rx.isEnabled).disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.taskListNameInput)
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .bind(to: viewModel.onTapCreateButton)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setViews() {
        backgroundColor = .white
        
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        nameTextField.placeholder = "Enter the title for new ToDo List"
        nameTextField.textAlignment = .center
        nameTextField.layer.borderColor = UIColor.systemBlue.cgColor
        nameTextField.layer.borderWidth = 1
        addSubview(nameTextField)
        
        createButton.backgroundColor = .systemBlue
        createButton.setTitle("Create", for: .normal)
        addSubview(createButton)
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints{ make in
            make.bottom.equalTo(nameTextField.snp.top).offset(-90)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        nameTextField.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        createButton.snp.makeConstraints{ make in
            make.top.equalTo(nameTextField.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }

}
