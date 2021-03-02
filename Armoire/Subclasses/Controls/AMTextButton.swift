//
//  AMTextButton.swift
//  Armoire
//
//  Created by Geraldine Turcios on 3/2/21.
//

import SwiftUI
import UIKit

class AMTextButton: UIButton {
    private var onAction: ((AMTextButton) -> Void)?

    override var isHighlighted: Bool {
        didSet {
            layer.opacity = isHighlighted ? 0.25 : 1
        }
    }

    convenience init(title: String, textColor: UIColor?) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton() {
        guard let customFont = UIFont(name: Fonts.quicksandMedium, size: 18) else {
            fatalError("Quicksand Medium custom font not found. Please make sure it is added to the bundle.")
        }

        addTarget(self, action: #selector(handleTapped), for: .touchUpInside)
        titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }

    func setOnAction(_ onAction: @escaping (AMTextButton) -> Void) {
        self.onAction = onAction
    }

    @objc private func handleTapped() {
        onAction?(self)
    }
}

#if DEBUG
struct AMTextButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview {
                AMTextButton(title: "Click Me", textColor: UIColor.accentColor)
            }
            UIViewPreview {
                AMTextButton(title: "Click Me", textColor: UIColor.accentColor)
            }
            .environment(\.sizeCategory, .accessibilityMedium)
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 200, height: 100)
    }
}
#endif
