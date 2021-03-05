//
//  SignUpScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 3/2/21.
//

import FirebaseAuth
import SwiftUI
import UIKit

class SignUpScreen: UIViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    let backButton = UIButton()
    let signUpLabel = AMBodyLabel(text: "Sign Up", fontSize: 34)
    let addAvatarImageButton = AMButton(title: "Add Avatar")
    let avatarImageView = UIImageView()
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
        configureAvatarImageView()
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
            make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
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

    func configureAvatarImageView() {
        contentStackView.addArrangedSubview(avatarImageView)
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.isHidden = true
        avatarImageView.snp.makeConstraints { $0.height.lessThanOrEqualTo(280) }

        contentStackView.addArrangedSubview(addAvatarImageButton)
        addAvatarImageButton.setOnAction(addAvatarImageButtonTapped)
        addAvatarImageButton.snp.makeConstraints { $0.height.equalTo(50) }
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

    func addAvatarImageButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.navigationBar.tintColor = UIColor.accentColor
        picker.delegate = self

        let alert = UIAlertController(title: "Photo", message: "Please select a method to add an image.", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.accentColor

        if let popoverController = alert.popoverPresentationController {
            // Sets the source of the alert for the popover
            popoverController.sourceView = view

            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        alert.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            guard let self = self else { return }
            picker.sourceType = .camera
            self.present(picker, animated: true)
        })

        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            guard let self = self else { return }
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
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
        // TODO: Implement functionality where avatar is properly uploaded to firebase for user
        guard let _ = avatarImageView.image else {
            return presentErrorAlert(message: "An image is required when adding a clothing item. Please add an image and try again.")
        }

        if firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return presentErrorAlert(message: "The first name field is empty. Please enter a first name.")
        } else if lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return presentErrorAlert(message: "The last name field is empty. Please enter a last name.")
        } else if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return presentErrorAlert(message: "The username field is empty. Please enter a username.")
        } else if password != confirmPassword {
            return presentErrorAlert(message: "The passwords entered do not match. Please try again.")
        }

        startLoadingOverlay(message: "Creating account")

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.presentErrorAlert(message: error.localizedDescription)
            } else {
                self.stopLoadingOverlay()
            }
        }
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

// MARK: - Image picker delegate

extension SignUpScreen: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        avatarImageView.image = image
        avatarImageView.isHidden = false
        dismiss(animated: true)
    }
}

// MARK: - Text field delegate

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
