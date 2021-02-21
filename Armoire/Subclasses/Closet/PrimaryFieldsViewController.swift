//
//  PrimaryFieldsViewController.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/26/21.
//

import UIKit

class PrimaryFieldsViewController: UIViewController {
    // MARK: - Properties

    let containerStackView = UIStackView()
    let addClothingImageButton = AMButton(title: "Add Image")
    let clothingImageView = UIImageView()
    let clothingNameTextField = AMTextField(placeholder: "Name")
    let clothingBrandTextField = AMTextField(placeholder: "Brand")

    var clothingName = ""
    var clothingBrand = ""

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    private func configureViewController() {
        view.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.spacing = 20
        containerStackView.snp.makeConstraints { $0.size.equalTo(view) }

        configureClothingImageView()
        configureClothingNameTextField()
        configureClothingBrandTextField()
    }

    func configureClothingImageView() {
        containerStackView.addArrangedSubview(clothingImageView)
        clothingImageView.contentMode = .scaleAspectFit
        clothingImageView.isHidden = true
        clothingImageView.snp.makeConstraints { $0.height.lessThanOrEqualTo(280) }

        containerStackView.addArrangedSubview(addClothingImageButton)
        addClothingImageButton.setOnAction(addClothingImageButtonTapped)
        addClothingImageButton.snp.makeConstraints { $0.height.equalTo(50) }
    }

    func configureClothingNameTextField() {
        containerStackView.addArrangedSubview(clothingNameTextField)
        clothingNameTextField.setOnEdit(handleClothingNameTextFieldEdit)
        clothingNameTextField.autocapitalizationType = .sentences
        clothingNameTextField.delegate = self
        clothingNameTextField.returnKeyType = .next
        clothingNameTextField.tag = 0
        clothingNameTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    private func configureClothingBrandTextField() {
        containerStackView.addArrangedSubview(clothingBrandTextField)
        clothingBrandTextField.setOnEdit(handleClothingBrandTextFieldEdit)
        clothingBrandTextField.autocapitalizationType = .sentences
        clothingBrandTextField.delegate = self
        clothingBrandTextField.returnKeyType = .done
        clothingBrandTextField.tag = 1
        clothingBrandTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    // MARK: - Defined Methods

    func addClothingImageButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.navigationBar.tintColor = UIColor.accentColor
        picker.delegate = self

        let alert = UIAlertController(title: "Photo", message: "Please select a method to add an image.", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.accentColor

        if let popoverController = alert.popoverPresentationController {
            // Sets the source of the alert for the popover
            popoverController.sourceView = view

            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        alert.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            guard let self = self else { return }
            picker.sourceType = .camera
            self.present(picker, animated: true)
        })

        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            guard let self = self else { return }
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    func handleClothingNameTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingName = text
    }

    func handleClothingBrandTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingBrand = text
    }
}

// MARK: - Image picker delegate

extension PrimaryFieldsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        clothingImageView.image = image
        clothingImageView.isHidden = false
        dismiss(animated: true)
    }
}

// MARK: - Text field delegate

extension PrimaryFieldsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: return clothingBrandTextField.becomeFirstResponder()
        case 1: return clothingBrandTextField.resignFirstResponder()
        default: return true
        }
    }
}
