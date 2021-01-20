//
//  AMBodyLabel.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SwiftUI
import UIKit

class AMBodyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(text: String, fontSize: CGFloat = 18) {
        self.init(frame: .zero)
        self.text = text
        let customFont = UIFont(name: Fonts.quicksandMedium, size: fontSize)!
        font = UIFontMetrics.default.scaledFont(for: customFont)
    }

    private func configureLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
    }
}

#if DEBUG
struct AMBodyLabelPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { AMBodyLabel(text: "Sample text", fontSize: 20) }
            UIViewPreview { AMBodyLabel(text: "Sample text", fontSize: 20) }
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 60)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
