//
//  AMTextField.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SwiftUI
import UIKit

class AMTextField: UITextField {
    private var onEdit: ((AMTextField) -> Void)?

    convenience init(text: String) {
        self.init(frame: .zero)
        placeholder = text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTextField() {
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(handleEdit), for: .editingChanged)

        layer.cornerRadius = 10
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.systemGray5.cgColor

        let customFont = UIFont(name: Fonts.quicksandMedium, size: 18)!
        font = UIFontMetrics.default.scaledFont(for: customFont)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12

        let leftPaddingView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        leftView = leftPaddingView
        leftViewMode = .always

        backgroundColor = .systemGray6
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .done
        clearButtonMode = .whileEditing
    }

    func setOnEdit(_ onEdit: @escaping (AMTextField) -> Void) {
        self.onEdit = onEdit
    }

    @objc private func handleEdit() {
        onEdit?(self)
    }
}

#if DEBUG
struct AMTextFieldPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { AMTextField(text: "Enter text") }
            UIViewPreview { AMTextField(text: "Enter text") }
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .previewLayout(.sizeThatFits)
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 60)
        .padding()
    }
}
#endif
