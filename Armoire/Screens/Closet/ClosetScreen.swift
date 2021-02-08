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
    let folderCountLabel = AMBodyLabel(text: "Loading folders...", fontSize: 18)

    var dataSource = FolderDataSource()

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.attributedPlaceholder = attributedString
        searchController.searchBar.tintColor = UIColor.accentColor
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
        tableView.showActivityIndicator()

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func fetchFolders() {
        FirebaseManager.shared.fetchFolders(for: "QePfaCJjbHIOmAZgfgTF") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let folders): self.setTableViewData(with: folders)
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
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

    func setTableViewData(with folders: [Folder]) {
        if folders.isEmpty {
            folderCountLabel.text = "0 folders"
        }

        dataSource.folders = folders
        tableView.hideActivityIndicator()
        tableView.reloadDataWithAnimation()
    }

    func addTableViewData(using folder: Folder) {
        dataSource.folders.append(folder)
        dataSource.sortFolders()
        tableView.reloadData()
    }

    @objc func plusButtonTapped(_ sender: UIBarButtonItem) {
        let folderFormScreen = FolderFormScreen()
        let destinationScreen = AMNavigationController(rootViewController: folderFormScreen)
        folderFormScreen.delegate = self
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
    }
}

// MARK: - Data source delegate

extension ClosetScreen: FolderDataSourceDelegate {
    func didUpdateDataSource(_ folders: [Folder]) {
        dataSource.sortFolders()
        let count = folders.count
        folderCountLabel.text = count == 1 ? "1 folder" : "\(count) folders"
    }

    func errorIsPresented(_ error: AMError) {
        presentErrorAlert(message: error.rawValue)
    }
}

// MARK: - Folder Form delegate

extension ClosetScreen: FolderFormScreenDelegate {
    func didCreateNewFolder(_ folder: Folder) {
        FirebaseManager.shared.createFolder(with: folder, for: "QePfaCJjbHIOmAZgfgTF") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let folder): self.addTableViewData(using: folder)
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
            }
        }
    }
}

// MARK: - Table view delegate

extension ClosetScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = dataSource.searchText.isEmpty ? dataSource.folders[indexPath.row] : dataSource.filteredFolders[indexPath.row]
        let folderScreen = FolderScreen(folder: folder)
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
        return UIHelper.favoriteFolderAction(dataSource: dataSource, tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - Search controller

extension ClosetScreen: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        dataSource.searchText = ""
        dataSource.filterFoldersWithSearchText()
        tableView.reloadDataWithAnimation()
    }
}

extension ClosetScreen: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        dataSource.searchText = searchText
        dataSource.filterFoldersWithSearchText()
        tableView.reloadDataWithAnimation()
    }
}

// MARK: - Previews

#if DEBUG
struct ClosetScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: ClosetScreen())
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
#endif
