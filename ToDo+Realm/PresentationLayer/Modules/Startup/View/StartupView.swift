//
//  StartupView.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 28/02/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit

final class StartupView: UIView {

    // MARK: - Private properties

    private let disposeBag = DisposeBag()
    
    private let launchImageView = UIImageView(image: UIImage(named: "launch") ?? UIImage())
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

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

    func bind(to viewModel: StartupViewModelBindable) {
        // Bindings UI controls to view model's input/output
        
        viewModel.shouldAnimateActivityIndicator
            .drive(onNext: { shouldAnimate in
                if shouldAnimate {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
    
    private func setViews() {
        addSubview(launchImageView)
        
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
    }
    
    private func setConstraints() {
        launchImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
