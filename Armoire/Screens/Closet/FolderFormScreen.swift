//
//  FolderFormScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/6/21.
//

import SwiftUI
import UIKit

// MARK: Delegate

protocol FolderFormScreenDelegate: class {
    func didCreateNewFolder(_ folder: Folder)
    func didUpdateExistingFolder(_ folder: Folder)
}

extension FolderFormScreenDelegate {
    func didCreateNewFolder(_ folder: Folder) {}
    func didUpdateExistingFolder(_ folder: Folder) {}
}

class FolderFormScreen: UIViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    let folderTitleTextField = AMTextField(placeholder: "Title")
    let folderDescriptionTextView = AMTextView(placeholder: "Enter description")
    let favoriteLabel = AMBodyLabel(text: "Mark as favorite?", fontSize: 20)
    let favoriteSwitch = AMSwitch(accentColor: UIColor.accentColor)

    var folderTitle = ""
    var folderDescription = ""
    var markedAsFavorite = false

    private var selectedFolder: Folder?

    weak var delegate: FolderFormScreenDelegate?

    // MARK: - Initializers

    init(selectedFolder: Folder? = nil) {
        // If selected folder is passed in, this screen will only be for updating that folder
        self.selectedFolder = selectedFolder
        super.init(nibName: nil, bundle: nil)
        setPreviousValues(for: selectedFolder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Configurations

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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .white
        } else if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        }
    }

    func configureScreen() {
        title = selectedFolder == nil ? "Create Folder" : "Edit Folder"

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
        scrollView.snp.makeConstraints { $0.size.equalTo(view) }

        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 20)

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
        folderTitleTextField.snp.makeConstraints { $0.height.equalTo(50) }
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

    func setPreviousValues(for folder: Folder?) {
        guard let folder = folder else { return }

        folderTitle = folder.title
        folderDescription = folder.description ?? ""
        markedAsFavorite = folder.isFavorite

        folderTitleTextField.text = folder.title
        favoriteSwitch.isOn = folder.isFavorite

        if let description = folder.description {
            folderDescriptionTextView.hidePlaceholder()
            folderDescriptionTextView.text = description
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
        if folderTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let alert = UIAlertController(title: "Error", message: "The title text field must not be empty.", preferredStyle: .alert)
            alert.view.tintColor = UIColor.accentColor
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            present(alert, animated: true)
        } else {
            if let folder = selectedFolder {
                let description = folderDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : folderDescription
                let updatedFolder = Folder(id: folder.id, title: folderTitle, description: description, isFavorite: markedAsFavorite)
                delegate?.didUpdateExistingFolder(updatedFolder)
                dismiss(animated: true)
            } else {
                let description = folderDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : folderDescription
                let folder = Folder(title: folderTitle, description: description, isFavorite: markedAsFavorite)
                delegate?.didCreateNewFolder(folder)
                dismiss(animated: true)
            }
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

extension FolderFormScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: return folderDescriptionTextView.becomeFirstResponder()
        default: return true
        }
    }
}

// MARK: - Text view delegate

extension FolderFormScreen: UITextViewDelegate {
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
struct FolderFormScreenPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewControllerPreview {
                AMNavigationController(rootViewController: FolderFormScreen())
            }
            .ignoresSafeArea(.all, edges: .all)
            UIViewControllerPreview {
                AMNavigationController(rootViewController: FolderFormScreen(selectedFolder: Folder.example))
            }
            .ignoresSafeArea(.all, edges: .all)
        }
    }
}
#endif
