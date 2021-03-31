//
//  TaskListCell.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 01.03.2021.
//

import UIKit
import SnapKit

class TaskListCell: UITableViewCell {
    
    static let reuseIdentifer = String(describing: TaskListCell.self)
    
    // MARK: - Private properties
    
    private let listImageView = UIImageView()
    private let titleLabel = UILabel()
    private let tasksCountLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TaskListCell.reuseIdentifer)
        
        setViews()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Public methods
    
    func configure(toDoList: TaskList) {
        listImageView.image = toDoList.image
        titleLabel.text = toDoList.name
        tasksCountLabel.text = "\(String(toDoList.tasks.filter { $0.isDone }.count)) of \(String(toDoList.tasks.count))"
    }
    
    // MARK: - Private methods
    
    func setViews() {
        selectionStyle = .none
        
        listImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(listImageView)
        
        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.addSubview(titleLabel)
        
        tasksCountLabel.numberOfLines = 1
        tasksCountLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(tasksCountLabel)
    }
    
    func setConstraints() {
        listImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(24)
            make.width.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.leading.equalTo(listImageView.snp.trailing).offset(8)
            make.top.bottom.equalTo(listImageView)
        }
        
        tasksCountLabel.snp.makeConstraints{ make in
            make.top.bottom.equalTo(listImageView)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
}
