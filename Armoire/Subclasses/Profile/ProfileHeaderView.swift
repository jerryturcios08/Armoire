//
//  ProfileHeaderView.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import SwiftUI
import UIKit

class ProfileHeaderView: UIView {
    let avatarImageView = AMImageView(frame: .zero)
    let fullNameLabel = UILabel(frame: .zero)
    let emailLabel = AMBodyLabel(text: "", fontSize: 20)
    let usernameLabel = AMBodyLabel(text: "", fontSize: 20)

    let headerViewPadding = 20

    private var user: User

    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        configureAvatarImageView()
        configureFullNameLabel()
        configureEmailLabel()
        configureUsernameLabel()
    }

    private func configureAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.image = UIImage(named: "CriticAvatar")
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        avatarImageView.layer.borderWidth = 1

        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(40)
            make.width.height.equalTo(120)
        }
    }

    private func configureFullNameLabel() {
        addSubview(fullNameLabel)
        fullNameLabel.text = "\(user.firstName) \(user.lastName)"
        fullNameLabel.lineBreakMode = .byTruncatingTail
        fullNameLabel.textAlignment = .center
        fullNameLabel.font = UIFontMetrics.default.scaledFont(for: UIFont(name: Fonts.quicksandBold, size: 30)!)
        fullNameLabel.adjustsFontForContentSizeCategory = true

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.left.equalTo(self).offset(headerViewPadding)
            make.right.equalTo(self).offset(-headerViewPadding)
        }
    }

    private func configureEmailLabel() {
        addSubview(emailLabel)
        emailLabel.text = user.email
        emailLabel.lineBreakMode = .byTruncatingTail
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom)
            make.left.equalTo(self).offset(headerViewPadding)
            make.right.equalTo(self).offset(-headerViewPadding)
        }
    }

    private func configureUsernameLabel() {
        addSubview(usernameLabel)
        usernameLabel.text = "@\(user.username)"
        usernameLabel.lineBreakMode = .byTruncatingTail
        usernameLabel.textColor = .secondaryLabel
        usernameLabel.textAlignment = .center

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom)
            make.left.equalTo(self).offset(headerViewPadding)
            make.right.equalTo(self).offset(-headerViewPadding)
            make.bottom.equalTo(self).offset(-40)
        }
    }
}

#if DEBUG
struct ProfileHeaderViewPreviews: PreviewProvider {
    static var previews: some View {
        UIViewPreview { ProfileHeaderView(user: User.example) }
            .previewLayout(.sizeThatFits)
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 300)
            .background(Color(.systemGray6))
    }
}
#endif
