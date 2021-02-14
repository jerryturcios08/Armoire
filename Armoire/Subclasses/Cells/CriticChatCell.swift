//
//  CriticChatCell.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/14/21.
//

import SwiftUI
import UIKit

struct Chat: Codable {
    var critic: User
    var messages: [Message]
}

class CriticChatCell: UITableViewCell {
    static let reuseId = "CriticChatCell"

    let separatorLine = UIView()

    let criticImageView = AMImageView(frame: .zero)
    let criticNameLabel = AMBodyLabel(text: "@notelena", fontSize: 18)
    let lastMessageLabel = AMBodyLabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Commodo nulla facilisi nullam vehicula ipsum a arcu. Sit amet justo donec enim diam. Senectus et netus et malesuada fames ac. Ultrices sagittis orci a scelerisque purus semper.", fontSize: 16)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(chat: Chat) {
        // TODO: Add avatar field to user
        criticNameLabel.text = chat.critic.username
        lastMessageLabel.text = chat.messages.last?.body
    }

    private func configureCell() {
        addSeparatorLine()
        configureCriticImageView()
        configureCriticNameLabel()
        configureLastMessageLabel()
    }

    private func configureCriticImageView() {
        addSubview(criticImageView)
        criticImageView.image = UIImage(named: "CriticAvatar")

        criticImageView.layer.cornerRadius = 40
        criticImageView.clipsToBounds = true
        criticImageView.layer.borderColor = UIColor.lightGray.cgColor
        criticImageView.layer.borderWidth = 1

        criticImageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(80)
        }
    }

    private func configureCriticNameLabel() {
        addSubview(criticNameLabel)

        criticNameLabel.snp.makeConstraints { make in
            make.top.equalTo(criticImageView)
            make.left.equalTo(criticImageView.snp.right).offset(12)
            make.right.equalTo(self).offset(-20)
        }
    }

    private func configureLastMessageLabel() {
        addSubview(lastMessageLabel)
        lastMessageLabel.textColor = .secondaryLabel
        lastMessageLabel.numberOfLines = 0
        lastMessageLabel.lineBreakMode = .byTruncatingTail

        lastMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(criticNameLabel.snp.bottom).offset(4)
            make.left.right.equalTo(criticNameLabel)
            make.bottom.equalTo(criticImageView)
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
struct CriticChatCellPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { CriticChatCell() }
            UIViewPreview { CriticChatCell() }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 100)
    }
}
#endif
