//
//  AMPrimaryLabel.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SwiftUI
import UIKit

class AMPrimaryLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(text: String, fontSize: CGFloat = 30) {
        self.init(frame: .zero)
        self.text = text
        let customFont = UIFont(name: Fonts.quicksandSemiBold, size: fontSize)!
        font = UIFontMetrics.default.scaledFont(for: customFont)
    }

    private func configureLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = UIColor(named: "AccentColor")
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
    }
}

#if DEBUG
struct AMPrimaryLabelPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { AMPrimaryLabel(text: "Sample text") }
            UIViewPreview { AMPrimaryLabel(text: "Sample text") }
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 60)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
