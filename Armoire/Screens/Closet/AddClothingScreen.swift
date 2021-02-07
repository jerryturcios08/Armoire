//
//  AddClothingScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/21/21.
//

import SwiftUI
import UIKit

protocol AddClothingScreenDelegate: class {
    func didAddNewClothing(_ clothing: Clothing, image: UIImage)
}

class AddClothingScreen: UIViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    let clothingQuantityLabel = AMBodyLabel(text: "Quantity: 0", fontSize: 20)
    let clothingQuantityStepper = UIStepper()
    let clothingColorLabel = AMBodyLabel(text: "Color", fontSize: 20)
    let clothingColorWell = UIColorWell()
    let favoriteLabel = AMBodyLabel(text: "Mark as favorite?", fontSize: 20)
    let favoriteSwitch = AMSwitch(accentColor: UIColor.accentColor)

    let additionalFieldsView = AdditionalFieldsView()
    let primaryFieldsViewController = PrimaryFieldsViewController()

    var clothingQuantity = 0 {
        didSet {
            clothingQuantityLabel.text = "Quantity: \(clothingQuantity)"
        }
    }

    var clothingColor: UIColor? = nil
    var markedAsFavorite = false

    weak var delegate: AddClothingScreenDelegate?

    // MARK: - Configurations

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureObservers()
        configureGestures()
        configureStackView()
        configurePrimaryFieldsViewController()
        configureSecondaryFields()
        contentStackView.addArrangedSubview(additionalFieldsView)
    }

    func configureScreen() {
        title = "Add Clothing"
        view.backgroundColor = .systemBackground

        let cancelButton = AMBarButtonItem(title: "Cancel", font: Fonts.quicksandMedium, onAction: cancelButtonTapped)
        navigationItem.leftBarButtonItem = cancelButton

        let doneButton = AMBarButtonItem(title: "Done", font: Fonts.quicksandBold, onAction: doneButtonTapped)
        navigationItem.rightBarButtonItem = doneButton
    }

    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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

    func configurePrimaryFieldsViewController() {
        addChild(primaryFieldsViewController)
        contentStackView.addArrangedSubview(primaryFieldsViewController.view)
    }

    func configureSecondaryFields() {
        configureClothingQuantityViews()
        configureClothingColorViews()
        configureFavoriteViews()
    }

    func configureClothingQuantityViews() {
        let quantityStackView = UIStackView(arrangedSubviews: [clothingQuantityLabel, clothingQuantityStepper])
        contentStackView.addArrangedSubview(quantityStackView)
        clothingQuantityStepper.addTarget(self, action: #selector(handleStepperValueChanged), for: .primaryActionTriggered)
    }

    func configureClothingColorViews() {
        let colorStackView = UIStackView(arrangedSubviews: [clothingColorLabel, clothingColorWell])
        contentStackView.addArrangedSubview(colorStackView)
        clothingColorWell.addTarget(self, action: #selector(handleColorValueChanged), for: .primaryActionTriggered)
        clothingColorWell.supportsAlpha = false
    }

    func configureFavoriteViews() {
        let favoriteStackView = UIStackView(arrangedSubviews: [favoriteLabel, favoriteSwitch])
        contentStackView.addArrangedSubview(favoriteStackView)
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

        guard let image = primaryFieldsViewController.clothingImageView.image else {
            alert.message = "An image is required when adding a clothing item. Please add an image and try again."
            present(alert, animated: true)
            return
        }

        guard let color = clothingColor else {
            alert.message = "A color was not selected for this clothing item. Please choose one from the color well and try again."
            present(alert, animated: true)
            return
        }

        if primaryFieldsViewController.clothingName.isEmpty {
            // Shows an error if a name was not entered
            alert.message = "A title is required when adding a clothing item. Please enter a title and try again."
            present(alert, animated: true)
        } else if primaryFieldsViewController.clothingBrand.isEmpty {
            // Shows an error if a brand was not entered
            alert.message = "A brand is required when adding a clothing item. Please enter a brand and try again."
            present(alert, animated: true)
        } else {
            let description = additionalFieldsView.clothingDescription
            let size = additionalFieldsView.clothingSize
            let material = additionalFieldsView.clothingMaterial
            let url = additionalFieldsView.clothingUrl

            let newClothing = Clothing(
                name: primaryFieldsViewController.clothingName,
                brand: primaryFieldsViewController.clothingBrand,
                quantity: clothingQuantity,
                color: color.toHexString(),
                isFavorite: markedAsFavorite,
                description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description,
                size: size.isEmpty ? nil : size,
                material: material.isEmpty ? nil : material,
                url: url.isEmpty ? nil : url
            )

            delegate?.didAddNewClothing(newClothing, image: image)
            startLoadingOverlay()

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self = self else { return }
                self.stopLoadingOverlay()
                self.dismiss(animated: true)
            }
        }
    }

    @objc func handleStepperValueChanged(_ sender: UIStepper) {
        clothingQuantity = Int(sender.value)
    }

    @objc func handleColorValueChanged(_ sender: UIColorWell) {
        guard let color = sender.selectedColor else { return }
        clothingColor = color
    }

    func handleFavoriteSwitchToggle(_ sender: UISwitch) {
        markedAsFavorite = sender.isOn
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        var keyboardSize = keyboardFrame.cgRectValue
        keyboardSize = view.convert(keyboardSize, from: nil)

        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardSize.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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
