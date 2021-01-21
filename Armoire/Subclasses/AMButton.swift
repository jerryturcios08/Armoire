//
//  AMButton.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import SwiftUI
import UIKit

class AMButton: UIButton {
    private var onAction: ((AMButton) -> Void)?

    override var isHighlighted: Bool {
        didSet {
            layer.opacity = isHighlighted ? 0.25 : 1
        }
    }

    convenience init(title: String, onAction: ((AMButton) -> Void)? = nil) {
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
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(handleTapped), for: .touchUpInside)

        let customFont = UIFont(name: Fonts.quicksandSemiBold, size: 20)!
        titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        titleLabel?.adjustsFontForContentSizeCategory = true

        backgroundColor = UIColor.accentColor
        setTitleColor(.systemBackground, for: .normal)
        layer.cornerRadius = 10
    }

    func setOnAction(_ onAction: @escaping (AMButton) -> Void) {
        self.onAction = onAction
    }

    @objc private func handleTapped() {
        onAction?(self)
    }
}

#if DEBUG
struct AMButtonPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView()
            ContainerView()
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .previewLayout(.sizeThatFits)
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
        .padding()
    }

    private struct ContainerView: UIViewRepresentable {
        func makeUIView(context: Context) -> UIButton { AMButton(title: "Click Me") }
        func updateUIView(_ uiView: UIButton, context: Context) {}
    }
}
#endif
