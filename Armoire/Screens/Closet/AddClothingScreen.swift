//
//  AddClothingScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/21/21.
//

import SwiftUI
import UIKit

protocol AddClothingScreenDelegate: class {
    func didAddNewClothing(_ clothing: Clothing)
}

class AddClothingScreen: UIViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    let clothingQuantityLabel = AMBodyLabel(text: "Quantity: 0", fontSize: 20)
    let clothingQuantityStepper = UIStepper()
    let clothingColorLabel = AMBodyLabel(text: "Color", fontSize: 20)
    let clothingColorButton = UIButton()
    let favoriteLabel = AMBodyLabel(text: "Mark as favorite?", fontSize: 20)
    let favoriteSwitch = AMSwitch(accentColor: UIColor.accentColor)

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

    weak var delegate: AddClothingScreenDelegate?

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureGestures()
        configureStackView()

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

    func configureStackView() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 20)

        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            make.width.equalTo(scrollView)
        }
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
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        alert.view.tintColor = UIColor.accentColor
        alert.addAction(UIAlertAction(title: "Okay", style: .default))

        if primaryFieldsViewController.clothingImageView.image == nil {
            // Shows an error if an image was not added
            alert.message = "An image is required when adding a clothing item. Please add an image and try again."
            present(alert, animated: true)
        } else if primaryFieldsViewController.clothingName.isEmpty {
            // Shows an error if a name was not entered
            alert.message = "A title is required when adding a clothing item. Please enter a title and try again."
            present(alert, animated: true)
        } else if primaryFieldsViewController.clothingBrand.isEmpty {
            // Shows an error if a brand was not entered
            alert.message = "A brand is required when adding a clothing item. Please enter a brand and try again."
            present(alert, animated: true)
        } else {
            // Additional fields
            let description = additionalFieldsView.clothingDescription
            let size = additionalFieldsView.clothingSize
            let material = additionalFieldsView.clothingMaterial
            let url = additionalFieldsView.clothingUrl

            let newClothing = Clothing(
                image: primaryFieldsViewController.clothingImageView.image!,
                name: primaryFieldsViewController.clothingName,
                brand: primaryFieldsViewController.clothingBrand,
                quantity: clothingQuantity,
                color: clothingColor.toHexString(),
                isFavorite: markedAsFavorite,
                description: description.isEmpty ? nil : description,
                size: size.isEmpty ? nil : size,
                material: material.isEmpty ? nil : material,
                url: url.isEmpty ? nil : url
            )

            delegate?.didAddNewClothing(newClothing)
            dismiss(animated: true)
        }
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
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
