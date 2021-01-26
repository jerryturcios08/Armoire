//
//  AMCanvasButton.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/25/21.
//

import SwiftUI
import UIKit

class AMCanvasButton: UIButton {
    private var onAction: ((AMCanvasButton) -> Void)?

    override var isHighlighted: Bool {
        didSet {
            layer.opacity = isHighlighted ? 0.25 : 1
        }
    }

    convenience init(image: UIImage?, onAction: ((AMCanvasButton) -> Void)? = nil) {
        self.init(frame: .zero)
        self.onAction = onAction
        setImage(image, for: .normal)
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

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    func setOnAction(_ onAction: @escaping (AMCanvasButton) -> Void) {
        self.onAction = onAction
    }

    @objc private func handleTapped() {
        onAction?(self)
    }
}

#if DEBUG
struct AMCanvasButtonPreview: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { AMCanvasButton(image: UIImage(named: "PlusButton")) }
                .background(Color(.systemGray5))
            UIViewPreview { AMCanvasButton(image: UIImage(named: "PlusButton")) }
                .background(Color(.darkGray))
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 100, height: 100)
    }
}
#endif
