//
//  ClothingCell.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SwiftUI
import UIKit

class ClothingCell: UITableViewCell {
    static let reuseId = "ClothingCell"

    let separatorLine = UIView()

    let clothingImageView = AMImageView(frame: .zero)
    let favoriteImageView = UIImageView(image: UIImage(systemName: SFSymbol.starFill)?.withRenderingMode(.alwaysOriginal))
    let clothingTitleLabel = AMPrimaryLabel(text: "Pink Dress", fontSize: 20)
    let clothingBrandLabel = AMBodyLabel(text: "Miss Collection")
    let clothingDescriptionLabel = AMBodyLabel(text: "My favorite dress out of everything in my collection. The fabric feels nice.")
    let clothingQuantityLabel = AMBodyLabel(text: "Quantity: 2")
    let clothingDateLabel = AMBodyLabel(text: "Last updated on 2/2/2020")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(clothing: Clothing) {
        if let imageUrl = clothing.imageUrl {
            clothingImageView.setImage(fromURL: imageUrl.absoluteString)
        }

        clothingTitleLabel.text = clothing.name
        clothingBrandLabel.text = clothing.brand
        clothingDescriptionLabel.text = clothing.description ?? "No description."
        clothingQuantityLabel.text = "Quantity: \(clothing.quantity)"

        if let starImage = UIImage(systemName: SFSymbol.starFill) {
            let starColor = clothing.isFavorite ? UIColor.systemYellow : UIColor.systemGray
            favoriteImageView.image = starImage.withRenderingMode(.alwaysOriginal).withTintColor(starColor)
        }

        if let date = clothing.dateUpdated {
            let dateString = date.convertToDayMonthYearFormat()
            clothingDateLabel.text = "Last updated on \(dateString)"
        } else {
            let dateString = clothing.dateCreated.convertToDayMonthYearFormat()
            clothingDateLabel.text = "Created on \(dateString)"
        }
    }

    private func configureCell() {
        addSeparatorLine()
        configureClothingImageView()
        configureFavoriteImageView()
        configureClothingTitleLabel()
        configureClothingBrandLabel()
        configureClothingDescriptionLabel()
        configureClothingQuantityLabel()
        configureClothingDateLabel()
    }

    private func configureClothingImageView() {
        addSubview(clothingImageView)

        clothingImageView.snp.makeConstraints { make in
            make.left.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(self).offset(9)
            make.bottom.equalTo(separatorLine).offset(-12)
            make.width.equalTo(100)
        }
    }

    private func configureFavoriteImageView() {
        addSubview(favoriteImageView)

        favoriteImageView.snp.makeConstraints { make in
            make.top.equalTo(clothingImageView)
            make.right.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.width.equalTo(22)
        }
    }

    private func configureClothingTitleLabel() {
        addSubview(clothingTitleLabel)

        clothingTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(clothingImageView.snp.right).offset(10)
            make.right.equalTo(favoriteImageView.snp.left)
            make.centerY.equalTo(favoriteImageView)
        }
    }

    private func configureClothingBrandLabel() {
        addSubview(clothingBrandLabel)
        clothingBrandLabel.font = UIFont(name: Fonts.quicksandSemiBold, size: 12)

        clothingBrandLabel.snp.makeConstraints { make in
            make.top.equalTo(clothingTitleLabel.snp.bottom).offset(6)
            make.left.equalTo(clothingTitleLabel)
            make.right.equalTo(favoriteImageView)
        }
    }

    private func configureClothingDescriptionLabel() {
        addSubview(clothingDescriptionLabel)
        clothingDescriptionLabel.font = UIFont(name: Fonts.quicksandRegular, size: 11)
        clothingDescriptionLabel.numberOfLines = 2

        clothingDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(clothingBrandLabel.snp.bottom).offset(6)
            make.left.equalTo(clothingBrandLabel)
            make.right.equalTo(favoriteImageView)
        }
    }

    private func configureClothingQuantityLabel() {
        addSubview(clothingQuantityLabel)
        clothingQuantityLabel.font = UIFont(name: Fonts.quicksandRegular, size: 9)
        clothingQuantityLabel.textColor = .secondaryLabel

        clothingQuantityLabel.snp.makeConstraints { make in
            make.left.equalTo(clothingDescriptionLabel)
            make.bottom.equalTo(clothingImageView)
        }
    }

    private func configureClothingDateLabel() {
        addSubview(clothingDateLabel)
        clothingDateLabel.font = UIFont(name: Fonts.quicksandRegular, size: 9)
        clothingDateLabel.textColor = .secondaryLabel

        clothingDateLabel.snp.makeConstraints { make in
            make.right.equalTo(favoriteImageView)
            make.bottom.equalTo(clothingImageView)
        }
    }

    private func addSeparatorLine() {
        addSubview(separatorLine)
        separatorLine.backgroundColor = UIColor.customSeparator

        separatorLine.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(4)
        }
    }
}

#if DEBUG
struct ClothingCellPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { ClothingCell() }
            UIViewPreview { ClothingCell() }
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 120)
        .previewLayout(.sizeThatFits)
    }
}
#endif
