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

    init(accentColor: UIColor?) {
        super.init(frame: .zero)
        guard let color = accentColor else { return }
        onTintColor = color
        addTarget(self, action: #selector(handleToggle), for: .primaryActionTriggered)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
