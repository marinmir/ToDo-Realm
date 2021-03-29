//
//  AddButton.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 10.03.2021.
//

import UIKit

class AddButton: UIButton {
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setTitle("+", for: .normal)
        titleLabel?.textColor = .white
        backgroundColor = .systemBlue
        layer.cornerRadius = 25
    }
}
