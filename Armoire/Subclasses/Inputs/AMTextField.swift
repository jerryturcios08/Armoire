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

    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTextField() {
        addTarget(self, action: #selector(handleEdit), for: .editingChanged)

        layer.cornerRadius = 10
        tintColor = UIColor.accentColor

        font = UIFont(name: Fonts.quicksandMedium, size: 18)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12

        let leftPaddingView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 0))
        leftView = leftPaddingView
        leftViewMode = .always

        backgroundColor = .systemGray5
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
            UIViewPreview { AMTextField(placeholder: "Enter text") }
            UIViewPreview { AMTextField(placeholder: "Enter text") }
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .previewLayout(.sizeThatFits)
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 60)
        .padding()
    }
}
#endif
