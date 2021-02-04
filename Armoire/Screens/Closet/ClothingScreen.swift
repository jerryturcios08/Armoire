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

    let stackView = UIStackView()

    let clothingImageView = AMImageView(frame: .zero)
    let clothingNameLabel = AMPrimaryLabel(text: "Pink Dress", fontSize: 36)
    let clothingColorImageView = UIImageView()
    let clothingBrandLabel = AMBodyLabel(text: "Miss Collection", fontSize: 24)
    let clothingDescriptionLabel = AMBodyLabel(text: "No description.")
    let clothingQuantityLabel = AMBodyLabel(text: "1 quantity", fontSize: 22)
    let sizeLabel = AMBodyLabel(text: "Size", fontSize: 22)
    let materialLabel = AMBodyLabel(text: "Material", fontSize: 22)

    private var clothing: Clothing

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
        configureStackView()
        configureClothingImageView()
        configureNameAndColorStackView()
        configureClothingBrandLabel()
        configureAboutSection()
        configureInfoSection()
        configureUrlSection()
        stackView.addArrangedSubview(UIView())
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

    func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.snp.makeConstraints { $0.size.equalTo(view) }
    }

    func configureClothingImageView() {
        stackView.addArrangedSubview(clothingImageView)
        clothingImageView.setImage(fromURL: clothing.imageUrl!.absoluteString)
        clothingImageView.contentMode = .scaleAspectFill
        clothingImageView.clipsToBounds = true
        clothingImageView.snp.makeConstraints { $0.height.equalTo(260) }
    }

    func configureNameAndColorStackView() {
        let nameAndColorStackView = UIStackView(arrangedSubviews: [clothingNameLabel, clothingColorImageView])
        stackView.addArrangedSubview(nameAndColorStackView)
//        constrainCommonPadding(view: nameAndColorStackView)
        clothingNameLabel.text = clothing.name

        let circleImage = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysOriginal)
        clothingColorImageView.image = circleImage
        clothingColorImageView.tintColor = UIColor(hex: clothing.color)
        clothingColorImageView.snp.makeConstraints { $0.width.height.equalTo(36) }
    }

    func configureClothingBrandLabel() {
        stackView.addArrangedSubview(clothingBrandLabel)
        clothingBrandLabel.text = clothing.brand
//        constrainCommonPadding(view: clothingBrandLabel)
    }

    func configureAboutSection() {
        createSectionHeaderView(for: "About")
        stackView.addArrangedSubview(clothingDescriptionLabel)
        clothingDescriptionLabel.text = clothing.description ?? "No description."
        clothingDescriptionLabel.setFont(with: UIFont(name: Fonts.quicksandRegular, size: 16))
        clothingDescriptionLabel.numberOfLines = 0
//        constrainCommonPadding(view: clothingDescriptionLabel)
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
            stackView.addArrangedSubview(urlButton)
//            constrainCommonPadding(view: urlButton)
        }
    }

    // MARK: - Defined methods

    private func createSectionHeaderView(for title: String) {
        let sectionHeaderStackView = UIStackView()
        sectionHeaderStackView.axis = .vertical
        sectionHeaderStackView.spacing = 4
        stackView.addArrangedSubview(sectionHeaderStackView)

        sectionHeaderStackView.addArrangedSubview(createSeparatorLine())

        let sectionHeaderLabel = AMBodyLabel(text: title)
        sectionHeaderStackView.addArrangedSubview(sectionHeaderLabel)
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
        stackView.addArrangedSubview(infoRowStackView)
        infoRowStackView.spacing = 8
//        constrainCommonPadding(view: infoRowStackView)
    }

    private func constrainCommonPadding(view: UIView) {
        view.snp.makeConstraints { make in
            make.left.equalTo(stackView).offset(12)
            make.right.equalTo(stackView).offset(-12)
        }
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
    }
}
#endif
