//
//  CustomButton.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 05.03.2021.
//

import UIKit

class CustomButton: UIButton {
    open override var isEnabled : Bool {
        willSet{
            backgroundColor = newValue ? .systemBlue : .gray
        }
    }
}

