//
//  ForgotPasswordScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 3/3/21.
//

import SwiftUI
import UIKit

class ForgotPasswordScreen: UIViewController {
    // MARK: - Properties

    let backButton = UIButton()
    let titleLabel = AMBodyLabel(text: "Forgot Password?")
    let descriptionLabel = AMBodyLabel(text: "Please enter the email you used to register your account. You should recieve password reset instructions in the entered email.", fontSize: 18)
    let emailTextField = AMTextField(placeholder: "Email")
    let resetButton = AMButton(title: "Reset")

    var email = ""

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureTitleLabel()
        configureDescriptionLabel()
        configureEmailTextField()
        configureResetButton()
    }

    func configureBackButton() {
        view.addSubview(backButton)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        backButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: configuration), for: .normal)
        backButton.addTarget(self, action: #selector(xmarkButtonTapped), for: .touchUpInside)
        backButton.tintColor = UIColor.accentColor
        backButton.snp.makeConstraints { $0.top.left.equalTo(view.layoutMarginsGuide) }
    }

    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.font = UIFont(name: Fonts.quicksandSemiBold, size: 30)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
    }

    func configureDescriptionLabel() {
        view.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view.layoutMarginsGuide)
        }
    }

    func configureEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.setOnEdit(handleEmailTextFieldEdit)
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .done

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.left.right.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
        }
    }

    func configureResetButton() {
        view.addSubview(resetButton)
        resetButton.setOnAction(handleResetButtonTapped)

        resetButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(50)
        }
    }

    // MARK: - Action methods

    @objc func xmarkButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func handleEmailTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        email = text
    }

    func handleResetButtonTapped(_ sender: UIButton) {
        // TODO: Implement reset functionality using Firebase
    }
}

// MARK: - Text field delegate

extension ForgotPasswordScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: return emailTextField.resignFirstResponder()
        default: return true
        }
    }
}

// MARK: - Previews

#if DEBUG
struct ForgotPasswordScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview { ForgotPasswordScreen() }
            .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
