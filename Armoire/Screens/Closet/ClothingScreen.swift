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
    let clothingQuantityLabel = AMBodyLabel(text: "1 quantity", fontSize: 22)
    let sizeLabel = AMBodyLabel(text: "Size", fontSize: 22)
    let materialLabel = AMBodyLabel(text: "Material", fontSize: 22)
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

        let starImageView = UIImageView(image: UIImage(systemName: SFSymbol.starFill))
        starImageView.tintColor = clothing.isFavorite ? .systemYellow : .systemGray
        starImageView.frame = .init(x: 0, y: 0, width: 30, height: 28)
        let markAsFavoriteItem = UIBarButtonItem(customView: starImageView)
        navigationItem.rightBarButtonItem = markAsFavoriteItem
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
        createInfoRowStackView(title: "Quantity", value: String(clothing.quantity))

        if let size = clothing.size {
            createInfoRowStackView(title: "Size", value: size)
        }

        if let material = clothing.material {
            createInfoRowStackView(title: "Material", value: material)
        }
    }

    func configureUrlSection() {
        if let url = clothing.url {
            createSectionHeaderView(for: "URL")
            let urlButton = AMLinkButton(title: url, onAction: urlButtonTapped)
            contentStackView.addArrangedSubview(hStackWithPadding(urlButton))
        }
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

    private func createInfoRowStackView(title: String, value: String) {
        let titleLabel = AMBodyLabel(text: title, fontSize: 16)
        let valueLabel = AMBodyLabel(text: value)
        valueLabel.setFont(with: UIFont(name: Fonts.quicksandRegular, size: 16))

        let infoRowStackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), valueLabel])
        contentStackView.addArrangedSubview(hStackWithPadding(infoRowStackView))
        infoRowStackView.spacing = 8
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

// MARK: - Previews

#if DEBUG
struct ClothingScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: ClothingScreen(clothing: Clothing.example))
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
