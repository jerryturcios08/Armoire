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

    // Stack views
    let screenStackView = UIStackView()
    let contentStackView = UIStackView()

    let clothingQuantityLabel = AMBodyLabel(text: "Quantity: 0", fontSize: 20)
    let clothingQuantityStepper = UIStepper()
    let clothingColorLabel = AMBodyLabel(text: "Color", fontSize: 20)
    let clothingColorButton = UIButton()
    let favoriteLabel = AMBodyLabel(text: "Mark as favorite?", fontSize: 20)
    let favoriteSwitch = AMSwitch(accentColor: UIColor.accentColor)

    // Views for additional fields
    let additionalFieldsView = AdditionalFieldsView()
    let primaryFieldsViewController = PrimaryFieldsViewController()

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

    var markedAsFavorite = false

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureGestures()
        configureStackViews()

        configureClothingQuantityViews()
        configureClothingColorViews()
        configureFavoriteViews()

        contentStackView.addArrangedSubview(additionalFieldsView)
    }

    func configureScreen() {
        title = "Add Clothing"
        view.backgroundColor = .systemBackground

        let cancelButton = AMBarButtonItem(title: "Cancel", font: Fonts.quicksandMedium, onAction: cancelButtonTapped)
        navigationItem.leftBarButtonItem = cancelButton

        let doneButton = AMBarButtonItem(title: "Done", font: Fonts.quicksandBold, onAction: doneButtonTapped)
        navigationItem.rightBarButtonItem = doneButton

        addChild(primaryFieldsViewController)
        contentStackView.addArrangedSubview(primaryFieldsViewController.view)
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
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = 20

        let insets = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 20)
        screenStackView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide).inset(insets) }
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
        clothingColorButton.tintColor = .systemPink
    }

    func configureFavoriteViews() {
        let favoriteStackView = UIStackView(arrangedSubviews: [favoriteLabel, favoriteSwitch])
        contentStackView.addArrangedSubview(favoriteStackView)
        favoriteStackView.spacing = 8
        favoriteSwitch.setOnAction(handleFavoriteSwitchToggle)
    }

    // MARK: - Defined methods

    func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
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

    func handleFavoriteSwitchToggle(_ sender: UISwitch) {
        markedAsFavorite = sender.isOn
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
