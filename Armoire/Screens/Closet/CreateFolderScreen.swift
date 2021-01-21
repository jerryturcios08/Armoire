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
    let folderDescriptionTextView = UITextView()
    let favoriteLabel = AMBodyLabel(text: "Mark as favorite?", fontSize: 20)
    let favoriteSwitch = UISwitch()

    var folderTitle = ""
    var folderDescription = ""
    var markedAsFavorite = false

    weak var delegate: CreateFolderScreenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureFolderTitleTextField()
        configureFavoriteSwitch()
        configureFavoriteLabel()
        configureFolderDescriptionTextView()
    }

    // MARK: - Configurations

    func configureScreen() {
        title = "Create Folder"
        view.backgroundColor = .systemBackground

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissScreen))
        navigationItem.leftBarButtonItem = cancelButton

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }

    func configureFolderTitleTextField() {
        view.addSubview(folderTitleTextField)
        folderTitleTextField.setOnEdit(handleFolderTitleTextFieldEdit)

        folderTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.height.equalTo(50)
        }
    }

    func configureFavoriteSwitch() {
        view.addSubview(favoriteSwitch)
        favoriteSwitch.onTintColor = UIColor(named: "AccentColor")

        favoriteSwitch.snp.makeConstraints { make in
            make.right.equalTo(folderTitleTextField)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    func configureFavoriteLabel() {
        view.addSubview(favoriteLabel)

        favoriteLabel.snp.makeConstraints { make in
            make.left.equalTo(folderTitleTextField)
            make.right.equalTo(favoriteSwitch).offset(-8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    func configureFolderDescriptionTextView() {
        view.addSubview(folderDescriptionTextView)
        folderDescriptionTextView.font = UIFont(name: Fonts.quicksandRegular, size: 20)
        folderDescriptionTextView.backgroundColor = .systemGray6
        folderDescriptionTextView.layer.cornerRadius = 10

        folderDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(folderTitleTextField.snp.bottom).offset(20)
            make.left.right.equalTo(folderTitleTextField)
            make.bottom.equalTo(favoriteSwitch.snp.top).offset(-20)
        }
    }

    // MARK: - Defined methods

    func handleFolderTitleTextFieldEdit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        folderTitle = text
    }

    @objc func doneButtonTapped() {
        let folder = Folder(title: folderTitle, description: folderDescription, favorite: markedAsFavorite)
        delegate?.didCreateNewFolder(folder)
        dismissScreen()
    }

    @objc func dismissScreen() {
        dismiss(animated: true)
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
