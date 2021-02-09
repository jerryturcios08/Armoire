//
//  ClothingScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SwiftUI
import UIKit

class ClothingScreen: UIViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let contentStackView = UIStackView()

    let clothingImageView = AMImageView(frame: .zero)
    let clothingNameLabel = AMPrimaryLabel(text: "Pink Dress", fontSize: 36)
    let clothingColorWell = UIColorWell()
    let clothingBrandLabel = AMBodyLabel(text: "Miss Collection", fontSize: 24)
    let clothingDescriptionLabel = AMBodyLabel(text: "No description.")
    let clothingQuantityValueLabel = AMBodyLabel(text: "1")
    let clothingSizeValueLabel = AMBodyLabel(text: "Small")
    let clothingMaterialValueLabel = AMBodyLabel(text: "Cotton")
    let clothingUrlButton = AMLinkButton()
    let dateCreatedLabel = AMBodyLabel(text: "Created on 1/1/2020", fontSize: 16)
    let dateUpdatedLabel = AMBodyLabel(text: "Updated on 1/1/2020", fontSize: 16)

    private var clothing: Clothing

    // MARK: - Initializers

    init(clothing: Clothing) {
        self.clothing = clothing
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureStackViews()
        configureClothingImageView()
        configureNameAndColorStackView()
        configureClothingBrandLabel()
        configureAboutSection()
        configureInfoSection()
        configureUrlSection()
        configureDateSection()
    }

    func configureScreen() {
        title = clothing.name
        view.backgroundColor = .systemBackground

        let editImage = UIImage(systemName: "square.and.pencil")
        let editClothingButton = UIBarButtonItem(image: editImage, style: .plain, target: self, action: #selector(editButtonTapped))

        let starImageView = UIImageView(image: UIImage(systemName: SFSymbol.starFill))
        starImageView.tintColor = clothing.isFavorite ? .systemYellow : .systemGray
        starImageView.frame = .init(x: 0, y: 0, width: 30, height: 28)
        let markAsFavoriteItem = UIBarButtonItem(customView: starImageView)

        navigationItem.rightBarButtonItems = [markAsFavoriteItem, editClothingButton]
    }

    func configureStackViews() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)

        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            make.width.equalTo(scrollView)
        }

        // Add the views to the stack view that make up the screen
        stackView.addArrangedSubviews(clothingImageView, contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
    }

    func configureClothingImageView() {
        clothingImageView.setImage(fromURL: clothing.imageUrl!.absoluteString)
        clothingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clothingImageTapped)))
        clothingImageView.isUserInteractionEnabled = true
        clothingImageView.contentMode = .scaleAspectFill
        clothingImageView.clipsToBounds = true
        clothingImageView.snp.makeConstraints { $0.height.equalTo(280) }
    }

    func configureNameAndColorStackView() {
        contentStackView.addArrangedSubview(hStackWithPadding(clothingNameLabel, clothingColorWell))
        clothingNameLabel.text = clothing.name
        clothingColorWell.selectedColor = UIColor(hex: clothing.color) ?? .systemRed
        clothingColorWell.isEnabled = false
    }

    func configureClothingBrandLabel() {
        contentStackView.addArrangedSubview(hStackWithPadding(clothingBrandLabel))
        clothingBrandLabel.text = clothing.brand
    }

    func configureAboutSection() {
        createSectionHeaderView(for: "About")
        contentStackView.addArrangedSubview(hStackWithPadding(clothingDescriptionLabel))
        clothingDescriptionLabel.text = clothing.description ?? "No description."
        clothingDescriptionLabel.setFont(with: UIFont(name: Fonts.quicksandRegular, size: 16))
        clothingDescriptionLabel.numberOfLines = 10
    }

    func configureInfoSection() {
        createSectionHeaderView(for: "Info")
        createInfoRowStackView(title: "Quantity", value: String(clothing.quantity), info: .quantity)
        createInfoRowStackView(title: "Size", value: clothing.size != nil ? clothing.size! : "N/a", info: .size)
        createInfoRowStackView(title: "Material", value: clothing.material != nil ? clothing.material! : "N/a", info: .material)
    }

    func configureUrlSection() {
        createSectionHeaderView(for: "URL")

        if let url = clothing.url {
            clothingUrlButton.setTitle(url, for: .normal)
            clothingUrlButton.setTitleColor(.systemTeal, for: .normal)
            clothingUrlButton.isEnabled = true
        } else {
            clothingUrlButton.setTitle("No URL available", for: .normal)
            clothingUrlButton.setTitleColor(.systemPink, for: .normal)
            clothingUrlButton.isEnabled = false
        }

        clothingUrlButton.setOnAction(urlButtonTapped(_:))
        contentStackView.addArrangedSubview(hStackWithPadding(clothingUrlButton))
    }

    func configureDateSection() {
        dateCreatedLabel.text = "Created on \(clothing.dateCreated.convertToDayMonthYearFormat())"
        dateCreatedLabel.textColor = .systemGray

        if let dateUpdated = clothing.dateUpdated {
            dateUpdatedLabel.text = "Updated on \(dateUpdated.convertToDayMonthYearFormat())"
            dateUpdatedLabel.textColor = .systemGray
            contentStackView.addArrangedSubview(hStackWithPadding(dateCreatedLabel, dateUpdatedLabel))
        } else {
            contentStackView.addArrangedSubview(hStackWithPadding(dateCreatedLabel))
        }
    }

    // MARK: - Defined methods

    private func createSectionHeaderView(for title: String) {
        let sectionHeaderStackView = UIStackView()
        sectionHeaderStackView.axis = .vertical
        sectionHeaderStackView.spacing = 4
        contentStackView.addArrangedSubview(sectionHeaderStackView)

        sectionHeaderStackView.addArrangedSubview(createSeparatorLine())

        let sectionHeaderLabel = AMBodyLabel(text: title)
        sectionHeaderStackView.addArrangedSubview(hStackWithPadding(sectionHeaderLabel))
        sectionHeaderLabel.textColor = .systemGray

        sectionHeaderStackView.addArrangedSubview(createSeparatorLine())
    }

    private func createSeparatorLine() -> UIView {
        let separatorLine = UIView()
        separatorLine.backgroundColor = .systemGray4
        separatorLine.snp.makeConstraints { $0.height.equalTo(1) }
        return separatorLine
    }

    private enum Info {
        case quantity, size, material
    }

    private func createInfoRowStackView(title: String, value: String, info: Info) {
        let titleLabel = AMBodyLabel(text: title, fontSize: 16)
        var valueLabel = AMBodyLabel()

        switch info {
        case .quantity:
            valueLabel = createValueLabel(value: value, label: clothingQuantityValueLabel)
        case .size:
            valueLabel = createValueLabel(value: value, label: clothingSizeValueLabel)
        case .material:
            valueLabel = createValueLabel(value: value, label: clothingMaterialValueLabel)
        }

        let infoRowStackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), valueLabel])
        contentStackView.addArrangedSubview(hStackWithPadding(infoRowStackView))
        infoRowStackView.spacing = 8
    }

    private func createValueLabel(value: String, label: AMBodyLabel) -> AMBodyLabel {
        label.text = value
        label.setFont(with: UIFont(name: Fonts.quicksandRegular, size: 16))
        return label
    }

    private func hStackWithPadding(_ views: UIView...) -> UIStackView {
        let hStack = UIStackView()
        hStack.addArrangedSubview(getPaddingSpacerView())
        views.forEach { hStack.addArrangedSubview($0) }
        hStack.addArrangedSubview(getPaddingSpacerView())
        return hStack
    }

    private func getPaddingSpacerView() -> UIView {
        let paddingSpacer = UIView()
        paddingSpacer.snp.makeConstraints { $0.width.equalTo(12) }
        return paddingSpacer
    }

    private func updateScreen(clothing: Clothing) {
        guard let imageUrlString = clothing.imageUrl?.absoluteString else { return }
        title = clothing.name

        clothingImageView.setImage(fromURL: imageUrlString)
        clothingNameLabel.text = clothing.name
        clothingBrandLabel.text = clothing.brand
        clothingColorWell.selectedColor = UIColor(hex: clothing.color)
        clothingDescriptionLabel.text = clothing.description ?? "No description."
        clothingQuantityValueLabel.text = "\(clothing.quantity)"
        clothingSizeValueLabel.text = clothing.size ?? "N/a"
        clothingMaterialValueLabel.text = clothing.material ?? "N/a"

        if let url = clothing.url {
            clothingUrlButton.setTitle(url, for: .normal)
            clothingUrlButton.setTitleColor(.systemTeal, for: .normal)
            clothingUrlButton.isEnabled = true
        } else {
            clothingUrlButton.setTitle("No URL available", for: .normal)
            clothingUrlButton.setTitleColor(.systemPink, for: .normal)
            clothingUrlButton.isEnabled = false
        }
    }

    // MARK: - Action methods

    @objc private func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let image = clothingImageView.image else { return }
        let clothingFormScreen = ClothingFormScreen(selectedClothing: clothing, selectedClothingImage: image)
        let destinationScreen = AMNavigationController(rootViewController: clothingFormScreen)
        clothingFormScreen.delegate = self
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
    }

    @objc private func clothingImageTapped(_ sender: UITapGestureRecognizer) {
        let imageViewerScreen = ImageViewerScreen(imageName: clothing.name, image: clothingImageView.image)
        imageViewerScreen.modalPresentationStyle = .overFullScreen
        imageViewerScreen.modalTransitionStyle = .crossDissolve
        present(imageViewerScreen, animated: true)
    }

    @objc private func urlButtonTapped(_ sender: UIButton) {
        guard let urlString = clothing.url else { return }
        guard let url = URL(string: urlString) else { return }
        presentSafariViewController(with: url)
    }
}

// MARK: - Clothing form delegate

extension ClothingScreen: ClothingFormScreenDelegate {
    func didUpdateExistingClothing(_ clothing: Clothing, image: UIImage) {
        FirebaseManager.shared.updateClothing(clothing, image: image) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let clothing): self.updateScreen(clothing: clothing)
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct ClothingScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: ClothingScreen(clothing: Clothing.example))
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
#endif
