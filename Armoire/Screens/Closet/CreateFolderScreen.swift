//
//  CreateFolderScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SwiftUI
import UIKit

protocol CreateFolderScreenDelegate: class {
    func didCreateNewFolder(_ folder: Folder)
}

class CreateFolderScreen: UIViewController {
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    let folderTitleTextField = AMTextField(placeholder: "Title")
    let folderDescriptionTextView = AMTextView(placeholder: "Enter description")
    let favoriteLabel = AMBodyLabel(text: "Mark as favorite?", fontSize: 20)
    let favoriteSwitch = AMSwitch(accentColor: UIColor.accentColor)

    var folderTitle = ""
    var folderDescription = ""
    var markedAsFavorite = false

    weak var delegate: CreateFolderScreenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureObservers()
        configureGestures()
        configureStackView()
        configureFolderTitleTextField()
        configureFolderDescriptionTextView()
        configureFavoriteViews()
    }

    // MARK: - Configurations

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func configureScreen() {
        title = "Create Folder"
        view.backgroundColor = .systemBackground

        let cancelButton = AMBarButtonItem(title: "Cancel", font: Fonts.quicksandMedium, onAction: cancelButtonTapped)
        navigationItem.leftBarButtonItem = cancelButton

        let doneButton = AMBarButtonItem(title: "Done", font: Fonts.quicksandBold, onAction: doneButtonTapped)
        navigationItem.rightBarButtonItem = doneButton
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

        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 20)

        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            make.width.equalTo(scrollView)
        }
    }

    func configureFolderTitleTextField() {
        contentStackView.addArrangedSubview(folderTitleTextField)
        folderTitleTextField.setOnEdit(handleFolderTitleTextFieldEdit)
        folderTitleTextField.autocapitalizationType = .sentences
        folderTitleTextField.delegate = self
        folderTitleTextField.returnKeyType = .next
        folderTitleTextField.tag = 0
        folderTitleTextField.snp.makeConstraints { $0.height.equalTo(50)
        }
    }

    func configureFolderDescriptionTextView() {
        contentStackView.addArrangedSubview(folderDescriptionTextView)
        folderDescriptionTextView.delegate = self
        folderDescriptionTextView.isScrollEnabled = false
    }

    func configureFavoriteViews() {
        let favoriteStackView = UIStackView(arrangedSubviews: [favoriteLabel, favoriteSwitch])
        contentStackView.addArrangedSubview(favoriteStackView)
        favoriteStackView.spacing = 8
        favoriteSwitch.setOnAction(handleFavoriteSwitchToggle)
    }

    // MARK: - Defined methods

    func handleFolderTitleTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        folderTitle = text
    }

    func handleFavoriteSwitchToggle(_ sender: UISwitch) {
        markedAsFavorite = sender.isOn
    }

    func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func doneButtonTapped(_ sender: UIBarButtonItem) {
        if folderTitle.isEmpty {
            let alert = UIAlertController(title: "Error", message: "The title text field must not be empty.", preferredStyle: .alert)
            alert.view.tintColor = UIColor.accentColor
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            present(alert, animated: true)
        } else {
            let description = folderDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : folderDescription
            let folder = Folder(title: folderTitle, description: description, isFavorite: markedAsFavorite)
            delegate?.didCreateNewFolder(folder)
            dismiss(animated: true)
        }
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        var keyboardSize = keyboardFrame.cgRectValue
        keyboardSize = view.convert(keyboardSize, from: nil)

        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardSize.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

// MARK: - Text field delegate

extension CreateFolderScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: return folderDescriptionTextView.becomeFirstResponder()
        default: return true
        }
    }
}

// MARK: - Text view delegate

extension CreateFolderScreen: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        folderDescription = text
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        folderDescriptionTextView.hidePlaceholder()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        folderDescriptionTextView.showPlaceholder()
    }
}

// MARK: - Previews

#if DEBUG
struct CreateFolderScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: CreateFolderScreen())
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
