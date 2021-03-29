//
//  TaskCell.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 10.03.2021.
//

import UIKit
import SnapKit

class TaskCell: UITableViewCell {
    
    static let reuseIdentifer = String(describing: TaskCell.self)
    
    var didSelectDone: ((Bool) -> Void)?
    
    // MARK: - Private properties
    
    private let doneButton = UIButton()
    private let titleLabel = UILabel()
    private let deadlineLabel = UILabel()
    private let dateFormatter = DateFormatter()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: TaskCell.reuseIdentifer)
        
        setupViews()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - Public methods
    
    func configure(task: Task) {
        titleLabel.text = task.name
        deadlineLabel.text = dateFormatter.string(from: task.deadline)
        doneButton.isSelected = task.isDone
        setTaskAppearance()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
    }
    
    // MARK: - Private methods
    
    @objc private func toggleDoneButton() {
        doneButton.isSelected.toggle()
        setTaskAppearance()
        didSelectDone?(doneButton.isSelected)
    }
    
    private func setTaskAppearance() {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: titleLabel.text ?? "")
        
        if doneButton.isSelected {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        }
        
        titleLabel.attributedText = attributeString
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        
        doneButton.addTarget(self, action: #selector(toggleDoneButton), for: .touchUpInside)
        doneButton.setBackgroundImage(UIImage(named: "notDoneButton"), for: .normal)
        doneButton.setBackgroundImage(UIImage(named: "doneButton"), for: .selected)
        doneButton.layer.cornerRadius = 20
        contentView.addSubview(doneButton)
        
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
        
        deadlineLabel.numberOfLines = 1
        deadlineLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(deadlineLabel)
    }
    
    private func setConstraints() {
        doneButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneButton.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalTo(contentView.snp.centerY).offset(-2)
        }
        
        deadlineLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(contentView.snp.centerY).offset(2)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
}
