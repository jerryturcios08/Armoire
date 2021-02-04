//
//  AMLinkButton.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/4/21.
//

import SwiftUI
import UIKit

class AMLinkButton: UIButton {
    private var onAction: ((AMLinkButton) -> Void)?

    override var isHighlighted: Bool {
        didSet {
            layer.opacity = isHighlighted ? 0.25 : 1
        }
    }

    convenience init(title: String, onAction: ((AMLinkButton) -> Void)? = nil) {
        self.init(frame: .zero)
        self.onAction = onAction
        setTitle(title, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton() {
        addTarget(self, action: #selector(handleTapped), for: .touchUpInside)

        let customFont = UIFont(name: Fonts.quicksandMedium, size: 16)!
        titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        titleLabel?.lineBreakMode = .byTruncatingTail
        titleLabel?.adjustsFontForContentSizeCategory = true
        setTitleColor(UIColor.systemTeal, for: .normal)
    }

    func setOnAction(_ onAction: @escaping (AMLinkButton) -> Void) {
        self.onAction = onAction
    }

    @objc private func handleTapped() {
        onAction?(self)
    }
}

#if DEBUG
struct AMLinkButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { AMLinkButton(title: "https://www.google.com") }
                .frame(width: 200, height: 30)
            UIViewPreview { AMLinkButton(title: "https://www.google.com") }
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityMedium)
                .frame(width: 310, height: 44)
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
