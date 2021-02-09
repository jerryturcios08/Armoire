//
//  ClothingFormScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/8/21.
//

import SwiftUI
import UIKit

// MARK: - Delegate

protocol ClothingFormScreenDelegate: class {
    func didAddNewClothing(_ clothing: Clothing, image: UIImage)
    func didUpdateExistingClothing(_ clothing: Clothing, image: UIImage)
}

extension ClothingFormScreenDelegate {
    func didAddNewClothing(_ clothing: Clothing, image: UIImage) {}
    func didUpdateExistingClothing(_ clothing: Clothing, image: UIImage) {}
}

class ClothingFormScreen: UIViewController {
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

    weak var delegate: ClothingFormScreenDelegate?

    private var selectedClothing: Clothing?
    private var selectedClothingImage: UIImage?

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    init(selectedClothing: Clothing, selectedClothingImage: UIImage) {
        self.selectedClothing = selectedClothing
        self.selectedClothingImage = selectedClothingImage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureObservers()
        configureGestures()
        configureStackView()
        configurePrimaryFieldsViewController()
        configureSecondaryFields()
        contentStackView.addArrangedSubview(additionalFieldsView)
        if selectedClothing != nil { setPreviousValues(for: selectedClothing, image: selectedClothingImage) }
    }

    func configureScreen() {
        title = selectedClothing == nil ? "Add Clothing" : "Edit Clothing"
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
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 20)

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

    func setPreviousValues(for clothing: Clothing?, image: UIImage?) {
        guard let clothing = clothing else { return }
        guard let image = image else { return }
        setPropertyValues(for: clothing, image: image)
        setViewValues(for: clothing)
    }

    func setPropertyValues(for clothing: Clothing, image: UIImage) {
        primaryFieldsViewController.clothingImageView.image = image
        primaryFieldsViewController.clothingImageView.isHidden = false
        primaryFieldsViewController.clothingName = clothing.name
        primaryFieldsViewController.clothingBrand = clothing.brand

        clothingQuantity = clothing.quantity
        clothingColor = UIColor(hex: clothing.color)
        markedAsFavorite = clothing.isFavorite

        additionalFieldsView.clothingDescription = clothing.description ?? ""
        additionalFieldsView.clothingSize = clothing.size ?? ""
        additionalFieldsView.clothingMaterial = clothing.material ?? ""
        additionalFieldsView.clothingUrl = clothing.url ?? ""
    }

    func setViewValues(for clothing: Clothing) {
        primaryFieldsViewController.clothingImageView.image = selectedClothingImage
        primaryFieldsViewController.clothingNameTextField.text = clothing.name
        primaryFieldsViewController.clothingBrandTextField.text = clothing.brand

        clothingQuantityStepper.value = Double(clothing.quantity)
        clothingColorWell.selectedColor = UIColor(hex: clothing.color)
        favoriteSwitch.isOn = clothing.isFavorite

        if let description = clothing.description {
            additionalFieldsView.clothingDescriptionTextView.hidePlaceholder()
            additionalFieldsView.clothingDescriptionTextView.text = description
        }

        if let size = clothing.size {
            additionalFieldsView.clothingSizeTextField.text = size
        }

        if let material = clothing.material {
            additionalFieldsView.clothingMaterialTextField.text = material
        }

        if let url = clothing.url {
            additionalFieldsView.clothingUrlTextField.text = url
        }
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

        if primaryFieldsViewController.clothingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Shows an error if a name was not entered
            alert.message = "A title is required when adding a clothing item. Please enter a title and try again."
            present(alert, animated: true)
        } else if primaryFieldsViewController.clothingBrand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Shows an error if a brand was not entered
            alert.message = "A brand is required when adding a clothing item. Please enter a brand and try again."
            present(alert, animated: true)
        } else {
            let name = primaryFieldsViewController.clothingName
            let brand = primaryFieldsViewController.clothingBrand

            let description = additionalFieldsView.clothingDescription
            let size = additionalFieldsView.clothingSize
            let material = additionalFieldsView.clothingMaterial
            let url = additionalFieldsView.clothingUrl

            if let clothing = selectedClothing {
                FirebaseManager.shared.deleteClothingImage(for: clothing) { [weak self] error in
                    guard let self = self else { return }
                    return self.presentErrorAlert(message: error.rawValue)
                }

                let updatedClothing = Clothing(
                    id: clothing.id,
                    name: name,
                    brand: brand,
                    quantity: clothingQuantity,
                    color: color.toHexString(),
                    isFavorite: markedAsFavorite,
                    description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description,
                    size: size.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : size,
                    material: material.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : material,
                    url: url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : url,
                    dateCreated: clothing.dateCreated,
                    dateUpdated: Date(),
                    folder: clothing.folder
                )

                delegate?.didUpdateExistingClothing(updatedClothing, image: image)
            } else {
                let newClothing = Clothing(
                    name: name,
                    brand: brand,
                    quantity: clothingQuantity,
                    color: color.toHexString(),
                    isFavorite: markedAsFavorite,
                    description: description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : description,
                    size: size.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : size,
                    material: material.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : material,
                    url: url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : url
                )

                delegate?.didAddNewClothing(newClothing, image: image)
            }

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
struct ClothingFormScreenPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewControllerPreview {
                AMNavigationController(rootViewController: ClothingFormScreen())
            }
            .ignoresSafeArea(.all, edges: .all)
            UIViewControllerPreview {
                AMNavigationController(
                    rootViewController: ClothingFormScreen(
                        selectedClothing: Clothing.example,
                        selectedClothingImage: UIImage(named: "PinkDress")!
                    )
                )
            }
            .ignoresSafeArea(.all, edges: .all)
        }
    }
}
#endif
