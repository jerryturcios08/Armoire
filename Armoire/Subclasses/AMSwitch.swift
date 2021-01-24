//
//  AMSwitch.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/23/21.
//

import SwiftUI
import UIKit

class AMSwitch: UISwitch {
    private var onAction: ((AMSwitch) -> Void)?
    private var accentColor: UIColor?

    init(accentColor: UIColor?) {
        super.init(frame: .zero)
        self.accentColor = accentColor
        configureSwitch()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSwitch() {
        addTarget(self, action: #selector(handleToggle), for: .primaryActionTriggered)
        onTintColor = accentColor
    }

    func setOnAction(_ onAction: @escaping (AMSwitch) -> Void) {
        self.onAction = onAction
    }

    @objc private func handleToggle() {
        onAction?(self)
    }
}

#if DEBUG
struct AMSwitchPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewPreview { AMSwitch(accentColor: UIColor.accentColor) }
            UIViewPreview { AMSwitch(accentColor: UIColor.accentColor) }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
