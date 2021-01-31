//
//  ClosetScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import SnapKit
import SwiftUI
import UIKit

class ClosetScreen: UIViewController {
    // MARK: - Properties

    let tableView = UITableView(frame: .zero, style: .grouped)
    let footerContainerView = UIView()
    let folderCountLabel = AMBodyLabel(text: "0 folders", fontSize: 18)

    var dataSource = FolderDataSource()

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
        fetchFolders()
    }

    func configureScreen() {
        title = "Closet"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButtonImage = UIImage(systemName: SFSymbol.plus)
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = addButton

        dataSource.delegate = self
    }

    func configureSearchController() {
        let searchController = UISearchController()
        let customFont = UIFont(name: Fonts.quicksandMedium, size: 17)!
        let textAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        let attributedString = NSAttributedString(string: "Search", attributes: textAttributes)

        searchController.searchBar.searchTextField.attributedPlaceholder = attributedString
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(FolderCell.self, forCellReuseIdentifier: FolderCell.reuseId)
        tableView.rowHeight = 90
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func fetchFolders() {
        FirebaseManager.shared.fetchFolderItems { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let folders): self.updateTableView(with: folders)
            case .failure(let error): print(error.rawValue)
            }
        }
    }

    // MARK: - Defined methods

    func createFooterView() -> UIView {
        footerContainerView.addSubview(folderCountLabel)
        folderCountLabel.textColor = .systemGray

        folderCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(footerContainerView)
        }

        return footerContainerView
    }

    func updateTableView(with folders: [Folder]) {
        dataSource.folders = folders
        tableView.reloadDataWithAnimation()
    }

    @objc func plusButtonTapped(_ sender: UIBarButtonItem) {
        let createFolderScreen = CreateFolderScreen()
        let destinationScreen = AMNavigationController(rootViewController: createFolderScreen)
        createFolderScreen.delegate = self
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
    }
}

// MARK: - Data source delegate

extension ClosetScreen: FolderDataSourceDelegate {
    func didUpdateDataSource(_ folders: [Folder]) {
        let count = folders.count
        folderCountLabel.text = count == 1 ? "1 folder" : "\(count) folders"
    }
}

// MARK: - Create folder delegate

extension ClosetScreen: CreateFolderScreenDelegate {
    func didCreateNewFolder(_ folder: Folder) {
        dataSource.folders.append(folder)
        tableView.reloadData()
    }
}

// MARK: - Table view delegate

extension ClosetScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = dataSource.folders[indexPath.row]
        let folderScreen = FolderScreen(folder: folder.title)
        navigationController?.pushViewController(folderScreen, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return createFooterView()
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let folder = dataSource.folders[indexPath.row]
        
        let actionColor = folder.isFavorite ? UIColor.systemGray : UIColor.systemYellow
        let actionTitle = folder.isFavorite ? "Unfavorite" : "Favorite"
        let actionImage = folder.isFavorite ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")

        let action = UIContextualAction(style: .normal, title: actionTitle) { [weak self] action, view, completionHandler in
            guard let self = self else { return }
            // TODO: Add a way to update the selected folder as favorited
            print(self.dataSource.folders)
            completionHandler(true)
        }

        action.backgroundColor = actionColor
        action.image = actionImage

        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - Previews

#if DEBUG
struct ClosetScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: ClosetScreen())
        }
    }
}
#endif
