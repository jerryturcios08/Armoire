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
    let clothingDescriptionTextView = AMTextView(placeholder: "Enter description")

    var clothingName = ""
    var clothingDescription = ""

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
        configureClothingDescriptionTextView()
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

    func configureClothingDescriptionTextView() {
        containerStackView.addArrangedSubview(clothingDescriptionTextView)
        clothingDescriptionTextView.delegate = self
        clothingDescriptionTextView.isScrollEnabled = false
    }

    // MARK: - Defined Methods

    func addClothingImageButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.navigationBar.tintColor = UIColor.accentColor
        picker.delegate = self

        let alert = UIAlertController(title: "Photo", message: "Please select a method to add an image.", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.accentColor

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
        case 0: return clothingDescriptionTextView.becomeFirstResponder()
        default: return true
        }
    }
}

// MARK: - Text view delegate

extension PrimaryFieldsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        clothingDescription = text
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        clothingDescriptionTextView.hidePlaceholder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        clothingDescriptionTextView.showPlaceholder()
    }
}
