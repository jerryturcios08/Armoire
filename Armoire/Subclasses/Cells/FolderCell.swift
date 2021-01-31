//
//  FolderCell.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SwiftUI
import UIKit

class FolderCell: UITableViewCell {
    static let reuseId = "FolderCell"

    let folderImageView = UIImageView(image: UIImage(systemName: SFSymbol.folder))
    let favoriteButton = UIButton()
    let folderTitleLabel = AMPrimaryLabel(text: "Dresses", fontSize: 20)
    let folderDescriptionLabel = AMBodyLabel(text: "My favorite dress out of everything in my collection. The fabric feels nice.", fontSize: 11)
    let folderQuantityLabel = AMBodyLabel(text: "4 items")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(folder: Folder) {
        folderTitleLabel.text = folder.title
        folderDescriptionLabel.text = folder.description ?? "No description."
        favoriteButton.setImage(UIImage(systemName: SFSymbol.starFill), for: .normal)
        favoriteButton.tintColor = folder.isFavorite ? UIColor.systemYellow : UIColor.systemGray
    }

    private func configureCell() {
        selectionStyle = .none
        configureFolderImageView()
        configureFavoriteButton()
        configureFolderTitleLabel()
        configureFolderDescriptionLabel()
        configureFolderQuantityLabel()
    }

    private func configureFolderImageView() {
        addSubview(folderImageView)
        folderImageView.tintColor = .systemGray4

        folderImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(16)
            make.width.equalTo(40)
            make.height.equalTo(32)
        }
    }

    private func configureFavoriteButton() {
        addSubview(favoriteButton)
        favoriteButton.setImage(UIImage(systemName: SFSymbol.starFill), for: .normal)
        favoriteButton.tintColor = .systemYellow

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(folderImageView)
            make.right.equalTo(self).offset(-16)
            make.width.equalTo(22)
        }
    }

    private func configureFolderTitleLabel() {
        addSubview(folderTitleLabel)

        folderTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(folderImageView.snp.right).offset(10)
            make.right.equalTo(favoriteButton)
            make.centerY.equalTo(favoriteButton)
        }
    }

    private func configureFolderDescriptionLabel() {
        addSubview(folderDescriptionLabel)
        folderDescriptionLabel.numberOfLines = 2

        folderDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(folderTitleLabel.snp.bottom)
            make.left.equalTo(folderTitleLabel)
            make.right.equalTo(favoriteButton)
        }
    }

    private func configureFolderQuantityLabel() {
        addSubview(folderQuantityLabel)
        folderQuantityLabel.font = UIFont(name: Fonts.quicksandRegular, size: 9)
        folderQuantityLabel.textColor = .secondaryLabel

        folderQuantityLabel.snp.makeConstraints { make in
            make.left.equalTo(folderDescriptionLabel)
            make.right.equalTo(favoriteButton)
            make.bottom.equalTo(self).offset(-8)
        }
    }
}

#if DEBUG
struct FolderCellPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { FolderCell() }
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 90)
        .previewLayout(.sizeThatFits)
    }
}
#endif
