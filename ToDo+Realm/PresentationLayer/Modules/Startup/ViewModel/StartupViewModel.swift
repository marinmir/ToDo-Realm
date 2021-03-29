//
//  StartupViewModel.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 28/02/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// Describes view model's input streams/single methods
protocol StartupViewModelInput {
    func startup()
}

/// Describes view model's output streams needed to update UI
protocol StartupViewModelOutput {
    var shouldAnimateActivityIndicator: Driver<Bool> { get }
}

protocol StartupViewModelBindable: StartupViewModelInput & StartupViewModelOutput {}

final class StartupViewModel: StartupModuleInput & StartupModuleOutput {
    private let disposeBag = DisposeBag()
    private let shouldAnimateActivityIndicatorRelay = BehaviorRelay<Bool>(value: true)
    
    var onComplete: ((StartupResult) -> Void)?
}

// MARK: - StartupViewModelBindable implementation

extension StartupViewModel: StartupViewModelBindable {
	// Describe all bindings here
    func startup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
            self?.shouldAnimateActivityIndicatorRelay.accept(false)
            self?.onComplete?(.success)
        }
    }
    
    var shouldAnimateActivityIndicator: Driver<Bool> {
        return shouldAnimateActivityIndicatorRelay.asDriver()
    }
}
