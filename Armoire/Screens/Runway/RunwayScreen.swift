//
//  RunwayScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import SwiftUI
import UIKit

class RunwayScreen: UIViewController {
    let primaryLabel = AMPrimaryLabel(text: "Welcome to runway Mode!", fontSize: 24)
    let subtitleLabel = AMBodyLabel(text: "This is a subtitle")
    let textField = AMTextField(text: "Runway name")
    let primaryButton = AMButton(title: "Let's begin")

    var runwayTitle = ""

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configurePrimaryLabel()
        configureSubtitleLabel()
        configureTextField()
        configurePrimaryButton()
    }

    // MARK: - Configuration

    func configureScreen() {
        title = "Runway"
        view.backgroundColor = .systemBackground
    }

    func configurePrimaryLabel() {
        view.addSubview(primaryLabel)

        primaryLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(60)
            make.centerX.equalTo(view)
        }
    }

    func configureSubtitleLabel() {
        view.addSubview(subtitleLabel)

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(primaryLabel.snp.bottom).offset(8)
            make.centerX.equalTo(view)
        }
    }

    func configureTextField() {
        view.addSubview(textField)
        textField.setOnEdit(handleTextFieldEdit)

        textField.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
        }
    }

    func configurePrimaryButton() {
        view.addSubview(primaryButton)
        primaryButton.setOnAction(primaryButtonTapped)

        primaryButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.bottom.equalTo(view).offset(-20)
            make.height.equalTo(50)
        }
    }

    // MARK: - Defined methods

    func primaryButtonTapped(_ sender: UIButton) {
        print("Hello!")
    }

    func handleTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        runwayTitle = text
        print(runwayTitle)
    }
}

// MARK: - Previews

#if DEBUG
struct RunwayScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: RunwayScreen())
        }
    }
}
#endif
