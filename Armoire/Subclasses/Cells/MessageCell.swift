//
//  MessageCell.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/13/21.
//

import SwiftUI
import UIKit

class MessageCell: UITableViewCell {
    static let reuseId = "MessageCell"

    let bubbleBackgroundView = UIView()
    let messageLabel = AMBodyLabel()

    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    var isIncoming = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(message: Message) {
        isIncoming = message.isIncoming

        bubbleBackgroundView.backgroundColor = isIncoming ? .systemGray5 : UIColor.accentColor
        messageLabel.text = message.body
        messageLabel.textColor = message.isIncoming ? .label : .white

        if isIncoming {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        } else {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        }
    }

    private func configureCell() {
        backgroundColor = .clear

        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)

        configureMessageLabel()
        configureBubbleBackgroundView()
    }

    private func configureMessageLabel() {
        messageLabel.numberOfLines = 0

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.bottom.equalTo(self).offset(-32)
            make.width.lessThanOrEqualTo(250)
        }
    }

    private func configureBubbleBackgroundView() {
        bubbleBackgroundView.backgroundColor = isIncoming ? UIColor.accentColor : .systemGray5
        bubbleBackgroundView.layer.cornerRadius = 20

        let padding = UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
        bubbleBackgroundView.snp.makeConstraints { $0.edges.equalTo(messageLabel).inset(padding) }

        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32)
    }
}
