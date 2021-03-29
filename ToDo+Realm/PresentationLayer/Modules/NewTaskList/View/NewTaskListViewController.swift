//
//  NewTaskListViewController.swift
//  ToDo+Realm
//
//  Created by Marina Miroshnichenko on 03/03/2021.
//  Copyright © 2021 Inostudio Solutions. All rights reserved.
//

import UIKit
import RxSwift

final class NewTaskListViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: NewTaskListViewModelBindable
    private let disposeBag = DisposeBag()

    // MARK: - Initializers

    init(viewModel: NewTaskListViewModelBindable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        // setImagePicker()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    override func loadView() {
        super.loadView()

        let view = NewTaskListView()
        view.bind(to: viewModel)

        self.view = view
        
        viewModel.shouldShowAlertChooseImage.emit(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.showAlertToChooseImage()
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        title = "New ToDo List"
    }
    
    // MARK: - Private methods
    
    private func showAlertToChooseImage() {
        let alertController = UIAlertController(title: "Choose source", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.openCamera(controller: alertController)
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.openGallery(controller: alertController)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func openCamera(controller: UIAlertController) {
        controller.dismiss(animated: true, completion: nil)
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            pickerController.sourceType = .camera
            present(pickerController, animated: true, completion: nil)
        } else {
            // do nothing or show alert
        }
    }
    
    private func openGallery(controller: UIAlertController) {
        controller.dismiss(animated: true, completion: nil)
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        } else {
            // do nothing
        }
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension NewTaskListViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.imageURL] as? URL,
           let image = info[.editedImage] as? UIImage {
            viewModel.selectedImageName.onNext(url.lastPathComponent)
            viewModel.selectedImage.onNext(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
