//
//  SignUpScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 3/2/21.
//

import SwiftUI
import UIKit

class SignUpScreen: UIViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    let backButton = UIButton()
    let signUpLabel = AMBodyLabel(text: "Sign Up", fontSize: 34)
    let firstNameTextField = AMTextField(placeholder: "First Name")
    let lastNameTextField = AMTextField(placeholder: "Last Name")
    let usernameTextField = AMTextField(placeholder: "@username")
    let emailTextField = AMTextField(placeholder: "Email")
    let passwordTextField = AMTextField(placeholder: "Password")
    let confirmPasswordTextField = AMTextField(placeholder: "Confirm Password")
    let registerButton = AMButton(title: "Register")

    var firstName = ""
    var lastName = ""
    var username = ""
    var email = ""
    var password = ""
    var confirmPassword = ""

    // MARK: - Configurations

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureObservers()
        configureGestures()
        configureStackView()
        configureBackButton()
        configureSignUpLabel()
        configureTextFields()
        configureRegisterButton()
    }

    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func configureGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func configureStackView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.size.equalTo(view) }

        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
            make.width.equalTo(scrollView)
        }
    }

    func configureBackButton() {
        let backButtonStackView = UIStackView(arrangedSubviews: [backButton, UIView()])
        contentStackView.addArrangedSubview(backButtonStackView)

        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        backButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: configuration), for: .normal)
        backButton.addTarget(self, action: #selector(xmarkButtonTapped), for: .touchUpInside)
        backButton.tintColor = UIColor.accentColor
    }

    func configureSignUpLabel() {
        contentStackView.addArrangedSubview(signUpLabel)
        signUpLabel.font = UIFont(name: Fonts.quicksandBold, size: 34)
    }

    func configureTextFields() {
        var tag = 0

        setCommonTextFieldProperties(for: firstNameTextField, tag: &tag, handleOnEdit: handleFirstNameTextFieldEdit)
        setCommonTextFieldProperties(for: lastNameTextField, tag: &tag, handleOnEdit: handleLastNameTextFieldEdit)
        setCommonTextFieldProperties(for: usernameTextField, tag: &tag, handleOnEdit: handleUsernameTextFieldEdit)
        setCommonTextFieldProperties(for: emailTextField, tag: &tag, handleOnEdit: handleEmailTextFieldEdit)
        setCommonTextFieldProperties(for: passwordTextField, tag: &tag, handleOnEdit: handlePasswordTextFieldEdit)
        setCommonTextFieldProperties(for: confirmPasswordTextField, tag: &tag, handleOnEdit: handleConfirmPasswordTextFieldEdit)

        firstNameTextField.autocapitalizationType = .words
        lastNameTextField.autocapitalizationType = .words
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.returnKeyType = .done
    }

    func configureRegisterButton() {
        contentStackView.addArrangedSubview(registerButton)
        registerButton.setOnAction(registerButtonTapped)
        registerButton.snp.makeConstraints { $0.height.equalTo(50) }
    }

    func setCommonTextFieldProperties(for textField: AMTextField, tag: inout Int, handleOnEdit: @escaping (UITextField) -> Void) {
        contentStackView.addArrangedSubview(textField)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.setOnEdit(handleOnEdit)
        textField.snp.makeConstraints { $0.height.equalTo(50) }

        textField.tag = tag
        tag += 1
    }

    // MARK: - Action methods

    @objc func xmarkButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func handleFirstNameTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        firstName = text
    }

    func handleLastNameTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        lastName = text
    }

    func handleUsernameTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        username = text
    }

    func handleEmailTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        email = text
    }

    func handlePasswordTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        password = text
    }

    func handleConfirmPasswordTextFieldEdit(_ sender: UITextField) {
        guard let text = sender.text else { return }
        confirmPassword = text
    }

    func registerButtonTapped(_ sender: UIButton) {
        // TODO: Handle registration logic and dismiss screen
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        var keyboardSize = keyboardFrame.cgRectValue
        keyboardSize = view.convert(keyboardSize, from: nil)

        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardSize.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension SignUpScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: return lastNameTextField.becomeFirstResponder()
        case 1: return usernameTextField.becomeFirstResponder()
        case 2: return emailTextField.becomeFirstResponder()
        case 3: return passwordTextField.becomeFirstResponder()
        case 4: return confirmPasswordTextField.becomeFirstResponder()
        case 5: return confirmPasswordTextField.resignFirstResponder()
        default: return true
        }
    }
}

// MARK: - Previews

#if DEBUG
struct SignUpScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview { SignUpScreen() }
            .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
