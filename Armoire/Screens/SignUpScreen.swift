//
//  SignUpScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 3/2/21.
//

import SwiftUI
import UIKit

class SignUpScreen: UIViewController {
    let backButton = UIButton()
    let signUpLabel = AMBodyLabel(text: "Sign Up", fontSize: 34)
    let firstNameTextField = AMTextField(placeholder: "First Name")
    let lastNameTextField = AMTextField(placeholder: "Last Name")
    let usernameTextField = AMTextField(placeholder: "@username")
    let emailTextField = AMTextField(placeholder: "Email")
    let passwordTextField = AMTextField(placeholder: "Password")
    let confirmPasswordTextField = AMTextField(placeholder: "Confirm Password")
    let registerButton = AMButton(title: "Register")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureBackButton()
        configureSignUpLabel()
        configureFirstNameTextField()
        configureLastNameTextField()
        configureUsernameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureConfirmPasswordTextField()
        configureRegisterButton()
    }

    func configureBackButton() {
        view.addSubview(backButton)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        backButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: configuration), for: .normal)
        backButton.addTarget(self, action: #selector(xmarkButtonTapped), for: .touchUpInside)
        backButton.tintColor = UIColor.accentColor
        backButton.snp.makeConstraints { $0.top.left.equalTo(view.layoutMarginsGuide) }
    }

    func configureSignUpLabel() {
        view.addSubview(signUpLabel)
        signUpLabel.font = UIFont(name: Fonts.quicksandBold, size: 34)

        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.left.right.equalTo(view.layoutMarginsGuide)
        }
    }

    func configureFirstNameTextField() {
        view.addSubview(firstNameTextField)

        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(signUpLabel.snp.bottom).offset(20)
            make.left.right.equalTo(signUpLabel)
            make.height.equalTo(50)
        }
    }

    func configureLastNameTextField() {
        view.addSubview(lastNameTextField)

        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
            make.left.right.equalTo(signUpLabel)
            make.height.equalTo(50)
        }
    }

    func configureUsernameTextField() {
        view.addSubview(usernameTextField)

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.left.right.equalTo(signUpLabel)
            make.height.equalTo(50)
        }
    }

    func configureEmailTextField() {
        view.addSubview(emailTextField)

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.left.right.equalTo(signUpLabel)
            make.height.equalTo(50)
        }
    }

    func configurePasswordTextField() {
        view.addSubview(passwordTextField)

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(signUpLabel)
            make.height.equalTo(50)
        }
    }

    func configureConfirmPasswordTextField() {
        view.addSubview(confirmPasswordTextField)

        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.right.equalTo(signUpLabel)
            make.height.equalTo(50)
        }
    }

    func configureRegisterButton() {
        view.addSubview(registerButton)

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
            make.left.right.equalTo(signUpLabel)
            make.height.equalTo(50)
        }
    }

    @objc func xmarkButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

#if DEBUG
struct SignUpScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview { SignUpScreen() }
            .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
