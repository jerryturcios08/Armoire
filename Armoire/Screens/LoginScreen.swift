//
//  LoginScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 3/2/21.
//

import SwiftUI
import UIKit

class LoginScreen: UIViewController {
    let loginLogoImageView = UIImageView(image: UIImage(named: "LoginLogo"))
    let loginLabel = AMBodyLabel(text: "Login", fontSize: 34)
    let emailTextField = AMTextField(placeholder: "Email")
    let passwordTextField = AMTextField(placeholder: "Password")
    let signInButton = AMButton(title: "Sign In")
    let forgotPasswordButton = UIButton()
    let signUpStackView = UIStackView()

    var email = ""
    var password = ""

    override func viewDidLoad() {
        super.viewDidLoad()
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

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.left.right.equalTo(loginLabel)
            make.height.equalTo(50)
        }
    }

    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.setOnEdit(handlePasswordTextFieldEdit)

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

        guard let customFont = UIFont(name: Fonts.quicksandMedium, size: 18) else {
            fatalError("Quicksand Medium custom font not found. Please make sure it is added to the bundle.")
        }

        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.setTitleColor(.systemGray, for: .normal)
        forgotPasswordButton.titleLabel?.adjustsFontForContentSizeCategory = true
        forgotPasswordButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)

        forgotPasswordButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(signInButton.snp.bottom).offset(20)
        }
    }

    private func configureSignUpStackView() {
        guard let customFont = UIFont(name: Fonts.quicksandMedium, size: 18) else {
            fatalError("Quicksand Medium custom font not found. Please make sure it is added to the bundle.")
        }

        let signUpLabel = AMBodyLabel(text: "Don't have an account?", fontSize: 18)

        let signUpButton = UIButton()
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(UIColor.accentColor, for: .normal)
        signUpButton.titleLabel?.adjustsFontForContentSizeCategory = true
        signUpButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)

        view.addSubview(signUpStackView)
        signUpStackView.addArrangedSubviews(UIView(), signUpLabel, signUpButton, UIView())
        signUpStackView.distribution = .fill
        signUpStackView.spacing = 8

        signUpStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-16)
        }
    }

    func handleEmailTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        email = text
    }

    func handlePasswordTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        password = text
    }

    @objc func forgotPasswordButtonTapped(_ sender: UIButton) {
        // Push to a new view controller for resetting the password
    }

    @objc func signUpButtonTapped(_ sender: UIButton) {
        // Push to a new view controller for creating an account
    }
}

#if DEBUG
struct LoginScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview { LoginScreen() }
            .ignoresSafeArea(.all, edges: .all)
    }
}

#endif
