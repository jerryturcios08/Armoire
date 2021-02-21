//
//  AvatarCell.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import SwiftUI
import UIKit

class AvatarCell: UITableViewCell {
    static let reuseId = "AvatarCell"

    let avatarImageView = AMImageView(frame: .zero)
    let detailLabel = AMBodyLabel(text: "Change Avatar", fontSize: 16)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(image: UIImage) {
        avatarImageView.image = image
    }

    private func configureCell() {
        configureAvatarImageView()
        configureDetailLabel()
    }

    private func configureAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.image = UIImage(named: "CriticAvatar")

        avatarImageView.layer.cornerRadius = 30
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        avatarImageView.layer.borderWidth = 1

        avatarImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.width.height.equalTo(60)
        }
    }

    private func configureDetailLabel() {
        addSubview(detailLabel)
        detailLabel.textColor = .secondaryLabel

        detailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-20)
        }
    }
}

#if DEBUG
struct AvatarCellPreviews: PreviewProvider {
    static var previews: some View {
        UIViewPreview { AvatarCell() }
            .previewLayout(.sizeThatFits)
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 84)
    }
}
#endif
