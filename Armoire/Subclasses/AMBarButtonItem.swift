//
//  AMBarButtonItem.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/23/21.
//

import SwiftUI
import UIKit

class AMBarButtonItem: UIBarButtonItem {
    private var onAction: ((AMBarButtonItem) -> Void)?

    init(title: String, font: String, onAction: ((AMBarButtonItem) -> Void)? = nil) {
        super.init()
        self.title = title
        self.onAction = onAction
        configureWithText(font: font)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureWithText(font: String) {
        action = #selector(handleAction)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: font, size: 17)!
        ]
        self.setTitleTextAttributes(textAttributes, for: .normal)
        self.setTitleTextAttributes(textAttributes, for: .highlighted)
    }

    func setOnAction(_ onAction: @escaping (AMBarButtonItem) -> Void) {
        self.onAction = onAction
    }

    @objc private func handleAction() {
        onAction?(self)
    }
}
