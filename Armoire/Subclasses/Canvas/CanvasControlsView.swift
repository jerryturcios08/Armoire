//
//  CanvasControlsView.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/25/21.
//

import SwiftUI
import UIKit

enum CanvasControl {
    case zoomIn
    case zoomOut
    case moveUp
    case moveLeft
    case moveRight
    case moveDown
}

class CanvasControlsView: UIView {
    let zoomOutButton = AMCanvasButton(image: UIImage(named: "MinusButton"))
    let zoomInButton = AMCanvasButton(image: UIImage(named: "PlusButton"))
    let panUpButton = AMCanvasButton(image: UIImage(named: "UpButton"))
    let panLeftButton = AMCanvasButton(image: UIImage(named: "LeftButton"))
    let panRightButton = AMCanvasButton(image: UIImage(named: "RightButton"))
    let panDownButton = AMCanvasButton(image: UIImage(named: "DownButton"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        // Zoom controls

        let zoomControlsStackView = UIStackView(arrangedSubviews: [zoomOutButton, zoomInButton])
        zoomControlsStackView.spacing = 8

        // Direction controls

        let moveXAxisStackView = UIStackView(arrangedSubviews: [panLeftButton, panRightButton])
        moveXAxisStackView.spacing = 8

        let moveControlsStackView = UIStackView(arrangedSubviews: [panUpButton, moveXAxisStackView, panDownButton])
        moveControlsStackView.axis = .vertical
        moveControlsStackView.spacing = 8

        // Controls stack view

        let stackView = UIStackView(arrangedSubviews: [zoomControlsStackView, moveControlsStackView])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 36

        stackView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.bottom.equalTo(self).offset(-16)
        }
    }

    func setAction(for control: CanvasControl, onAction: @escaping (AMCanvasButton) -> Void) {
        switch control {
        case .zoomOut: zoomOutButton.setOnAction(onAction)
        case .zoomIn: zoomInButton.setOnAction(onAction)
        case .moveUp: panUpButton.setOnAction(onAction)
        case .moveLeft: panLeftButton.setOnAction(onAction)
        case .moveRight: panRightButton.setOnAction(onAction)
        case .moveDown: panDownButton.setOnAction(onAction)
        }
    }
}

#if DEBUG
struct CanvasControlsViewPreviews: PreviewProvider {
    static var previews: some View {
        UIViewPreview { CanvasControlsView() }
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(.systemGray5))
    }
}
#endif
