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
    let folderTitleTextField = AMTextField(text: "Title")
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
        configureGestures()
        configureFolderTitleTextField()
        configureFolderDescriptionTextView()
        configureFavoriteSwitch()
        configureFavoriteLabel()
    }

    // MARK: - Configurations

    func configureScreen() {
        title = "Create Folder"
        view.backgroundColor = .systemBackground

        let cancelButton = AMBarButtonItem(title: "Cancel", font: Fonts.quicksandMedium, onAction: cancelButtonTapped)
        navigationItem.leftBarButtonItem = cancelButton

        let doneButton = AMBarButtonItem(title: "Done", font: Fonts.quicksandBold, onAction: doneButtonTapped)
        navigationItem.rightBarButtonItem = doneButton
    }

    func configureGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func configureFolderTitleTextField() {
        view.addSubview(folderTitleTextField)
        folderTitleTextField.setOnEdit(handleFolderTitleTextFieldEdit)
        folderTitleTextField.autocapitalizationType = .sentences
        folderTitleTextField.delegate = self
        folderTitleTextField.returnKeyType = .next
        folderTitleTextField.tag = 0

        folderTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }

    func configureFolderDescriptionTextView() {
        view.addSubview(folderDescriptionTextView)
        folderDescriptionTextView.delegate = self
        folderDescriptionTextView.isScrollEnabled = false

        folderDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(folderTitleTextField.snp.bottom).offset(20)
            make.left.right.equalTo(folderTitleTextField)
        }
    }

    func configureFavoriteSwitch() {
        view.addSubview(favoriteSwitch)
        favoriteSwitch.setOnAction(handleFavoriteSwitchToggle)

        favoriteSwitch.snp.makeConstraints { make in
            make.top.equalTo(folderDescriptionTextView.snp.bottom).offset(20)
            make.right.equalTo(folderDescriptionTextView)
        }
    }

    func configureFavoriteLabel() {
        view.addSubview(favoriteLabel)

        favoriteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(favoriteSwitch)
            make.left.equalTo(folderDescriptionTextView)
            make.right.equalTo(favoriteSwitch).offset(-8)
        }
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
            let description = folderDescription.isEmpty ? nil : folderDescription
            let folder = Folder(title: folderTitle, description: description, favorite: markedAsFavorite)
            delegate?.didCreateNewFolder(folder)
            dismiss(animated: true)
        }
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        folderTitleTextField.resignFirstResponder()
        folderDescriptionTextView.resignFirstResponder()
    }
}

// MARK: - Text field delegate

extension CreateFolderScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            folderDescriptionTextView.becomeFirstResponder()
        default:
            return true
        }

        return true
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
    }
}
#endif
