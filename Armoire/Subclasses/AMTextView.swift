//
//  AMTextView.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/23/21.
//

import SwiftUI
import UIKit

class AMTextView: UITextView {
    private var placeholder: String?

    init(placeholder: String) {
        super.init(frame: .zero, textContainer: .none)
        self.placeholder = placeholder
        configureTextView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTextView() {
        text = placeholder
        textColor = .systemGray2
        font = UIFont(name: Fonts.quicksandMedium, size: 18)
        backgroundColor = .systemGray6
        tintColor = UIColor.accentColor
        layer.cornerRadius = 10
        textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
    }

    func hidePlaceholder() {
        if textColor == UIColor.systemGray2 {
            text = nil
            textColor = .label
        }
    }

    func showPlaceholder() {
        if text.isEmpty {
            text = placeholder
            textColor = .systemGray2
        }
    }
}

#if DEBUG
struct AMTextViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { AMTextView(placeholder: "Enter text...") }
            UIViewPreview { AMTextView(placeholder: "Enter text...") }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 200, height: 200)
        .padding()
        .disabled(true)
    }
}
#endif
