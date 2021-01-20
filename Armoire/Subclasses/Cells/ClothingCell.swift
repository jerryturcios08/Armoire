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

    let clothingImageView = UIImageView()
    let favoriteButton = UIButton()
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

    func set(clothing: String) {

    }

    private func configureCell() {
        selectionStyle = .none
        addSeparatorLine()
        configureClothingImageView()
        configureFavoriteButton()
        configureClothingTitleLabel()
        configureClothingBrandLabel()
        configureClothingDescriptionLabel()
        configureClothingQuantityLabel()
        configureClothingDateLabel()
    }

    private func configureClothingImageView() {
        addSubview(clothingImageView)
        clothingImageView.image = UIImage(named: "PinkDress")
        clothingImageView.contentMode = .scaleAspectFill
        clothingImageView.clipsToBounds = true

        clothingImageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(14)
            make.top.equalTo(self).offset(9)
            make.bottom.equalTo(separatorLine).offset(-12)
            make.width.equalTo(100)
        }
    }

    private func configureFavoriteButton() {
        addSubview(favoriteButton)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        favoriteButton.tintColor = .systemYellow

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(clothingImageView)
            make.right.equalTo(self).offset(-14)
            make.width.equalTo(22)
        }
    }

    private func configureClothingTitleLabel() {
        addSubview(clothingTitleLabel)

        clothingTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(clothingImageView.snp.right).offset(10)
            make.right.equalTo(favoriteButton.snp.left)
            make.centerY.equalTo(favoriteButton)
        }
    }

    private func configureClothingBrandLabel() {
        addSubview(clothingBrandLabel)
        clothingBrandLabel.font = UIFont(name: Fonts.quicksandSemiBold, size: 12)

        clothingBrandLabel.snp.makeConstraints { make in
            make.top.equalTo(clothingTitleLabel.snp.bottom).offset(6)
            make.left.equalTo(clothingTitleLabel)
            make.right.equalTo(favoriteButton.snp.right)
        }
    }

    private func configureClothingDescriptionLabel() {
        addSubview(clothingDescriptionLabel)
        clothingDescriptionLabel.font = UIFont(name: Fonts.quicksandRegular, size: 11)
        clothingDescriptionLabel.numberOfLines = 2

        clothingDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(clothingBrandLabel.snp.bottom).offset(6)
            make.left.equalTo(clothingBrandLabel)
            make.right.equalTo(favoriteButton)
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
            make.right.equalTo(favoriteButton)
            make.bottom.equalTo(clothingImageView)
        }
    }

    private func addSeparatorLine(){
        addSubview(separatorLine)
        separatorLine.backgroundColor = .systemGray6

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
