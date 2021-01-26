//
//  AddClothingScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/21/21.
//

import SwiftUI
import UIKit

class AddClothingScreen: UIViewController {
    // MARK: - Properties

    let screenStackView = UIStackView()
    let contentStackView = UIStackView()

    let clothingNameTextField = AMTextField(placeholder: "Name")
    let clothingDescriptionTextView = AMTextView(placeholder: "Enter description")
    let clothingSizeTextField = AMTextField(placeholder: "Size")
    let clothingQuantityLabel = AMBodyLabel(text: "Quantity: 0", fontSize: 20)
    let clothingQuantityStepper = UIStepper()
    let clothingColorLabel = AMBodyLabel(text: "Color", fontSize: 20)
    let clothingColorButton = UIButton()
    let clothingBrandTextField = AMTextField(placeholder: "Brand")
    let clothingMaterialTextField = AMTextField(placeholder: "Material")
    let clothingUrlTextField = AMTextField(placeholder: "URL")
    let favoriteLabel = AMBodyLabel(text: "Mark as favorite?", fontSize: 20)
    let favoriteSwitch = AMSwitch(accentColor: UIColor.accentColor)

    var clothingName = ""
    var clothingDescription = ""
    var clothingSize = ""

    var clothingQuantity = 0 {
        didSet {
            clothingQuantityLabel.text = "Quantity: \(clothingQuantity)"
        }
    }

    var clothingColor = UIColor.systemPink {
        didSet {
            clothingColorButton.tintColor = clothingColor
        }
    }

    var clothingBrand = ""
    var clothingMaterial = ""
    var clothingUrl = ""
    var markedAsFavorite = false

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureGestures()
        configureStackViews()
        configureClothingNameTextField()
        configureClothingDescriptionTextView()
        configureClothingSizeTextField()
        configureClothingQuantityViews()
        configureClothingColorViews()
        configureClothingBrandTextField()
        configureClothingMaterialTextField()
        configureClothingUrlTextField()
        configureFavoriteViews()
    }

    func configureScreen() {
        title = "Add Clothing"
        view.backgroundColor = .systemBackground

        let cancelButton = AMBarButtonItem(title: "Cancel", font: Fonts.quicksandMedium, onAction: cancelButtonTapped)
        navigationItem.leftBarButtonItem = cancelButton

        let doneButton = AMBarButtonItem(title: "Done", font: Fonts.quicksandBold, onAction: doneButtonTapped)
        navigationItem.rightBarButtonItem = doneButton
    }

    func configureGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func configureStackViews() {
        view.addSubview(screenStackView)
        screenStackView.axis = .vertical
        screenStackView.addArrangedSubviews(contentStackView, UIView())

        // Content stack view contains all form inputs
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = 20

        screenStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20) // Need to tweak
        }
    }

    func configureClothingNameTextField() {
        contentStackView.addArrangedSubview(clothingNameTextField)
        clothingNameTextField.setOnEdit(handleClothingNameTextFieldEdit)
        setCommonTextFieldProperties(for: clothingNameTextField)
        clothingNameTextField.tag = 0
        clothingNameTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    func configureClothingDescriptionTextView() {
        contentStackView.addArrangedSubview(clothingDescriptionTextView)
        clothingDescriptionTextView.delegate = self
        clothingDescriptionTextView.isScrollEnabled = false
    }

    func configureClothingSizeTextField() {
        contentStackView.addArrangedSubview(clothingSizeTextField)
        clothingSizeTextField.setOnEdit(handleClothingSizeTextFieldEdit)
        setCommonTextFieldProperties(for: clothingSizeTextField)
        clothingSizeTextField.tag = 1
        clothingSizeTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    func configureClothingQuantityViews() {
        let quantityStackView = UIStackView(arrangedSubviews: [clothingQuantityLabel, clothingQuantityStepper])
        contentStackView.addArrangedSubview(quantityStackView)
        quantityStackView.spacing = 8
        clothingQuantityStepper.addTarget(self, action: #selector(handleStepperValueChanged), for: .primaryActionTriggered)
    }

    func configureClothingColorViews() {
        let colorStackView = UIStackView(arrangedSubviews: [clothingColorLabel, clothingColorButton])
        contentStackView.addArrangedSubview(colorStackView)
        colorStackView.distribution = .equalSpacing
        colorStackView.spacing = 8

        clothingColorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        clothingColorButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        clothingColorButton.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
        clothingColorButton.tintColor = .systemPink
    }

    func configureClothingBrandTextField() {
        contentStackView.addArrangedSubview(clothingBrandTextField)
        clothingBrandTextField.setOnEdit(handleClothingSizeTextFieldEdit)
        setCommonTextFieldProperties(for: clothingBrandTextField)
        clothingBrandTextField.tag = 2
        clothingBrandTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    func configureClothingMaterialTextField() {
        contentStackView.addArrangedSubview(clothingMaterialTextField)
        clothingMaterialTextField.setOnEdit(handleClothingMaterialTextFieldEdit)
        setCommonTextFieldProperties(for: clothingMaterialTextField)
        clothingMaterialTextField.tag = 3
        clothingMaterialTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    func configureClothingUrlTextField() {
        contentStackView.addArrangedSubview(clothingUrlTextField)
        clothingUrlTextField.setOnEdit(handleClothingUrlTextFieldEdit)
        clothingUrlTextField.delegate = self
        clothingUrlTextField.keyboardType = .URL
        clothingUrlTextField.returnKeyType = .done
        clothingUrlTextField.tag = 4
        clothingUrlTextField.snp.makeConstraints { $0.height.equalTo(50) }
    }

    func configureFavoriteViews() {
        let favoriteStackView = UIStackView(arrangedSubviews: [favoriteLabel, favoriteSwitch])
        contentStackView.addArrangedSubview(favoriteStackView)
        favoriteStackView.spacing = 8
        favoriteSwitch.setOnAction(handleFavoriteSwitchToggle)
    }

    // MARK: - Defined methods

    func setCommonTextFieldProperties(for textField: UITextField) {
        textField.autocapitalizationType = .sentences
        textField.delegate = self
        textField.returnKeyType = .next
    }

    func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func handleClothingNameTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingName = text
    }

    func handleClothingSizeTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingSize = text
    }

    @objc func handleStepperValueChanged(_ sender: UIStepper) {
        clothingQuantity = Int(sender.value)
    }

    @objc func colorButtonTapped(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = clothingColorButton.tintColor
        colorPicker.supportsAlpha = false
        present(colorPicker, animated: true)
    }

    func handleClothingBrandTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingBrand = text
    }

    func handleClothingMaterialTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingMaterial = text
    }

    func handleClothingUrlTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clothingUrl = text
    }

    func handleFavoriteSwitchToggle(_ sender: UISwitch) {
        markedAsFavorite = sender.isOn
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        clothingNameTextField.resignFirstResponder()
        clothingDescriptionTextView.resignFirstResponder()
        clothingSizeTextField.resignFirstResponder()
        clothingBrandTextField.resignFirstResponder()
        clothingMaterialTextField.resignFirstResponder()
        clothingUrlTextField.resignFirstResponder()
    }
}

// MARK: - Text field delegate

extension AddClothingScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            clothingDescriptionTextView.becomeFirstResponder()
        case 1:
            clothingBrandTextField.becomeFirstResponder()
        case 2:
            clothingMaterialTextField.becomeFirstResponder()
        case 3:
            clothingUrlTextField.becomeFirstResponder()
        case 4:
            clothingUrlTextField.resignFirstResponder()
        default:
            return true
        }

        return true
    }
}

// MARK: - Text view delegate

extension AddClothingScreen: UITextViewDelegate {
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

// MARK: - Color picker delegate

extension AddClothingScreen: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        clothingColor = viewController.selectedColor
    }
}

// MARK: - Previews

#if DEBUG
struct AddClothingScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: AddClothingScreen())
        }
    }
}
#endif
