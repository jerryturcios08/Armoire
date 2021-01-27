//
//  AdditionalFieldsView.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/26/21.
//

import UIKit

class AdditionalFieldsView: UIView {
    // MARK: - Properties

    let containerStackView = UIStackView()
    let additionalFieldsStackView = UIStackView()
    let additionalFieldsButton = AMButton(title: "Show Additional Fields")
    let clothingSizeTextField = AMTextField(placeholder: "Size")
    let clothingBrandTextField = AMTextField(placeholder: "Brand")
    let clothingMaterialTextField = AMTextField(placeholder: "Material")
    let clothingUrlTextField = AMTextField(placeholder: "URL")

    private var additionalFieldsVisible = false {
        didSet {
            let title = additionalFieldsVisible ? "Hide Additional Fields" : "Show Additional Fields"
            additionalFieldsButton.setTitle(title, for: .normal)
        }
    }

    var clothingSize = ""
    var clothingBrand = ""
    var clothingMaterial = ""
    var clothingUrl = ""

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurations

    private func configureView() {
        // Configures the outermost stackview
        addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.spacing = 20
        containerStackView.snp.makeConstraints { $0.size.equalTo(self) }
        configureAdditionalFieldsButton()

        // Configures the stackview containing the fields
        containerStackView.addArrangedSubview(additionalFieldsStackView)
        additionalFieldsStackView.axis = .vertical
        additionalFieldsStackView.distribution = .equalSpacing
        additionalFieldsStackView.spacing = 20

        additionalFieldsStackView.alpha = 0
        additionalFieldsStackView.isHidden = true

        configureClothingSizeTextField()
        configureClothingBrandTextField()
        configureClothingMaterialTextField()
        configureClothingUrlTextField()
    }

    private func configureAdditionalFieldsButton() {
        containerStackView.addArrangedSubview(additionalFieldsButton)
        additionalFieldsButton.setOnAction(additionalFieldsButtonTapped)
        additionalFieldsButton.snp.makeConstraints { $0.height.equalTo(50) }
    }

    private func configureClothingSizeTextField() {
        additionalFieldsStackView.addArrangedSubview(clothingSizeTextField)
        clothingSizeTextField.setOnEdit(handleClothingSizeTextFieldEdit)
        setCommonTextFieldProperties(for: clothingSizeTextField)
        clothingSizeTextField.tag = 0
        clothingSizeTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    private func configureClothingBrandTextField() {
        additionalFieldsStackView.addArrangedSubview(clothingBrandTextField)
        clothingBrandTextField.setOnEdit(handleClothingSizeTextFieldEdit)
        setCommonTextFieldProperties(for: clothingBrandTextField)
        clothingBrandTextField.tag = 1
        clothingBrandTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    private func configureClothingMaterialTextField() {
        additionalFieldsStackView.addArrangedSubview(clothingMaterialTextField)
        clothingMaterialTextField.setOnEdit(handleClothingMaterialTextFieldEdit)
        setCommonTextFieldProperties(for: clothingMaterialTextField)
        clothingMaterialTextField.tag = 2
        clothingMaterialTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    private func configureClothingUrlTextField() {
        additionalFieldsStackView.addArrangedSubview(clothingUrlTextField)
        clothingUrlTextField.setOnEdit(handleClothingUrlTextFieldEdit)
        clothingUrlTextField.delegate = self
        clothingUrlTextField.keyboardType = .URL
        clothingUrlTextField.returnKeyType = .done
        clothingUrlTextField.tag = 3
        clothingUrlTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    // MARK: - Defined methods

    private func setCommonTextFieldProperties(for textField: UITextField) {
        textField.autocapitalizationType = .sentences
        textField.delegate = self
        textField.returnKeyType = .next
    }

    private func additionalFieldsButtonTapped(_ sender: UIButton) {
        additionalFieldsVisible.toggle()

        if additionalFieldsVisible {
            UIView.transition(with: additionalFieldsStackView, duration: 0.5, options: .transitionCurlDown, animations: { [weak self] in
                guard let self = self else { return }
                self.additionalFieldsStackView.alpha = 1
                self.additionalFieldsStackView.isHidden = false
            })
        } else {
            UIView.transition(with: additionalFieldsStackView, duration: 0.5, options: .transitionCurlUp, animations: { [weak self] in
                guard let self = self else { return }
                self.additionalFieldsStackView.alpha = 0
                self.additionalFieldsStackView.isHidden = true
            })
        }
    }

    private func handleClothingSizeTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingSize = text
    }

    private func handleClothingBrandTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingBrand = text
    }

    private func handleClothingMaterialTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingMaterial = text
    }

    private func handleClothingUrlTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingUrl = text
    }
}

// MARK: - Text field delegate

extension AdditionalFieldsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: return clothingBrandTextField.becomeFirstResponder()
        case 1: return clothingMaterialTextField.becomeFirstResponder()
        case 2: return clothingUrlTextField.becomeFirstResponder()
        case 3: return clothingUrlTextField.resignFirstResponder()
        default: return true
        }
    }
}
