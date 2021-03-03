//
//  LoginScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 3/2/21.
//

import SwiftUI
import UIKit

class LoginScreen: UIViewController {
    // MARK: - Properties

    let loginLogoImageView = UIImageView(image: UIImage(named: "LoginLogo"))
    let loginLabel = AMBodyLabel(text: "Login", fontSize: 34)
    let emailTextField = AMTextField(placeholder: "Email")
    let passwordTextField = AMTextField(placeholder: "Password")
    let signInButton = AMButton(title: "Sign In")
    let forgotPasswordButton = AMTextButton(title: "Forgot password?", textColor: .systemGray)
    let signUpLabel = AMBodyLabel(text: "Don't have an account?", fontSize: 18)
    let signUpButton = AMTextButton(title: "Sign Up", textColor: UIColor.accentColor)
    let signUpStackView = UIStackView()

    var email = ""
    var password = ""

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureGestures()
        configureLoginLogoImageView()
        configureLoginLabel()
        configureEmailTextField()
        configurePasswordTextField()
        configureSignInButton()
        configureForgotPasswordButton()
        configureSignUpStackView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let largeSizeCategories: [UIContentSizeCategory] = [
            .accessibilityMedium,
            .accessibilityLarge,
            .accessibilityExtraLarge,
            .accessibilityExtraExtraLarge,
            .accessibilityExtraExtraExtraLarge
        ]

        if largeSizeCategories.contains(traitCollection.preferredContentSizeCategory) {
            signUpStackView.axis = .vertical
        }
    }

    private func configureGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    private func configureLoginLogoImageView() {
        view.addSubview(loginLogoImageView)
        loginLogoImageView.contentMode = .scaleAspectFit

        loginLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view).offset(36)
            make.right.equalTo(view).offset(-36)
        }
    }

    private func configureLoginLabel() {
        view.addSubview(loginLabel)
        loginLabel.font = UIFont(name: Fonts.quicksandBold, size: 34)

        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLogoImageView.snp.bottom).offset(36)
            make.left.right.equalTo(view.layoutMarginsGuide)
        }
    }

    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.setOnEdit(handleEmailTextFieldEdit)
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.tag = 0

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.left.right.equalTo(loginLabel)
            make.height.equalTo(50)
        }
    }

    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.setOnEdit(handlePasswordTextFieldEdit)
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        passwordTextField.tag = 1

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(loginLabel)
            make.height.equalTo(50)
        }
    }

    private func configureSignInButton() {
        view.addSubview(signInButton)

        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.right.equalTo(loginLabel)
            make.height.equalTo(50)
        }
    }

    private func configureForgotPasswordButton() {
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.setOnAction(forgotPasswordButtonTapped)

        forgotPasswordButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(signInButton.snp.bottom).offset(20)
        }
    }

    private func configureSignUpStackView() {
        view.addSubview(signUpStackView)
        signUpButton.setOnAction(signUpButtonTapped)
        signUpStackView.addArrangedSubviews(UIView(), signUpLabel, signUpButton, UIView())
        signUpStackView.distribution = .fill
        signUpStackView.spacing = 8

        signUpStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-24)
        }
    }

    // MARK: - Action methods

    func handleEmailTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        email = text
    }

    func handlePasswordTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        password = text
    }

    func forgotPasswordButtonTapped(_ sender: UIButton) {
    }

    func signUpButtonTapped(_ sender: UIButton) {
        let destinationScreen = SignUpScreen()
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - Text field delegate

extension LoginScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: return passwordTextField.becomeFirstResponder()
        case 1: return passwordTextField.resignFirstResponder()
        default: return true
        }
    }
}

// MARK: - Previews

#if DEBUG
struct LoginScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview { LoginScreen() }
            .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
