//
//  EditTitleField.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/13/21.
//

import SwiftUI
import UIKit

class EditTitleField: UIView {
    let textField = AMTextField(placeholder: "Enter title")

    private var previousTitle: String

    init(previousTitle: String) {
        self.previousTitle = previousTitle
        super.init(frame: .zero)
        configureView()
        configureTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColorScheme()
    }

    private func configureView() {
        updateColorScheme()

        layer.borderWidth = 1
        layer.cornerRadius = 15

        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
    }

    private func configureTextField() {
        addSubview(textField)
        textField.autocapitalizationType = .sentences
        textField.autocorrectionType = .yes
        textField.returnKeyType = .done

        textField.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
    }

    private func updateColorScheme() {
        if traitCollection.userInterfaceStyle == .light {
            backgroundColor = .systemBackground
            layer.borderColor = UIColor.systemBackground.cgColor
        } else if traitCollection.userInterfaceStyle == .dark {
            backgroundColor = .secondarySystemFill
            layer.borderColor = UIColor.secondarySystemFill.cgColor
        }
    }
}

#if DEBUG
struct EditTitleFieldPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { EditTitleField(previousTitle: "Wedding Outfit 2021") }
            UIViewPreview { EditTitleField(previousTitle: "Wedding Outfit 2021") }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 60)
        .padding()
    }
}
#endif
