//
//  NewTaskView.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 11/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit

final class NewTaskView: UIView {

    // MARK: - Private properties

    private let disposeBag = DisposeBag()
    
    private let nameTextField = UITextField()
    private let deadlineTextField = UITextField()
    private let notesTextView = UITextView()
    private let createButton = CustomButton()
    private let datePicker = UIDatePicker()

    private let notesPlaceholder = "Write some notes for this task"
    
    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        setupViews()
        setConstraints()
        
        notesTextView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func bind(to viewModel: NewTaskViewModelBindable) {
        // Bindings UI controls to view model's input/output
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        datePicker.rx.controlEvent(.valueChanged)
            .withLatestFrom(datePicker.rx.date)
            .bind(to: viewModel.deadline)
            .disposed(by: disposeBag)
        
        notesTextView.rx.text.orEmpty
            .map { $0 != self.notesPlaceholder ? $0 : "" }
            .bind(to: viewModel.notes)
            .disposed(by: disposeBag)
        
        viewModel.canCreateTask
            .drive(createButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .bind(to: viewModel.onTapCreateButton)
            .disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func setupViews() {
        backgroundColor = .white
        
        nameTextField.placeholder = "Enter task name"
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.blue.cgColor
        nameTextField.textAlignment = .center
        addSubview(nameTextField)
        
        deadlineTextField.placeholder = "Enter the date"
        deadlineTextField.layer.borderWidth = 1
        deadlineTextField.layer.borderColor = UIColor.blue.cgColor
        datePicker.datePickerMode = .dateAndTime
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        
        deadlineTextField.inputAccessoryView = toolBar
        deadlineTextField.inputView = datePicker
        deadlineTextField.textAlignment = .center
        addSubview(deadlineTextField)
        
        setNotesPlaceholder()
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.blue.cgColor
        addSubview(notesTextView)
        
        createButton.backgroundColor = .blue
        createButton.setTitle("Create", for: .normal)
        addSubview(createButton)
    }

    private func setConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        deadlineTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(44)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        
        createButton.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(44)
        }
        
        notesTextView.snp.makeConstraints { make in
            make.top.equalTo(deadlineTextField.snp.bottom).offset(20)
            make.bottom.equalTo(createButton.snp.top).offset(-20)
            make.leading.trailing.equalTo(nameTextField)
        }
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        deadlineTextField.text = formatter.string(from: datePicker.date)
        endEditing(true)
    }
    
    private func setNotesPlaceholder() {
        notesTextView.text = notesPlaceholder
        notesTextView.textColor = .lightGray
    }
}

// MARK: - UITextFieldDelegate

extension NewTaskView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.textColor == UIColor.lightGray {
            notesTextView.text = nil
            notesTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTextView.text.isEmpty {
            setNotesPlaceholder()
        }
    }
    
}
