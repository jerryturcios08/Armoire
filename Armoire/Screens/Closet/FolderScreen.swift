//
//  FolderScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SnapKit
import SwiftUI
import UIKit

class FolderScreen: UIViewController {
    // MARK: - Properties

    let tableView = UITableView(frame: .zero, style: .grouped)
    let footerContainerView = UIView()
    let itemCountLabel = AMBodyLabel(text: "Loading items...", fontSize: 18)

    private var folder: Folder
    var dataSource = ClothesDataSource()

    // MARK: - Initializers

    init(folder: Folder) {
        self.folder = folder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchClothes()
    }

    func configureScreen() {
        title = folder.title
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        let editFolderAction = UIAction(title: "Edit folder", image: UIImage(systemName: "pencil"), handler: editButtonTapped)
        let addClothingAction = UIAction(title: "Add clothing", image: UIImage(systemName: "plus"), handler: addButtonTapped)
        let folderMenu = UIMenu(title: "", children: [editFolderAction, addClothingAction])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: folderMenu)

        dataSource.delegate = self
    }

    func configureSearchController() {
        let searchController = UISearchController()
        let customFont = UIFont(name: Fonts.quicksandMedium, size: 17)!
        let textAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        let attributedString = NSAttributedString(string: "Search Clothes", attributes: textAttributes)

        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.attributedPlaceholder = attributedString
        searchController.searchBar.tintColor = UIColor.accentColor
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(ClothingCell.self, forCellReuseIdentifier: ClothingCell.reuseId)
        tableView.rowHeight = 121
        tableView.separatorStyle = .none
        tableView.showActivityIndicator()
        tableView.snp.makeConstraints { $0.size.equalTo(view) }
    }

    func fetchClothes() {
        guard let id = folder.id else { return }

        FirebaseManager.shared.fetchClothes(for: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let clothes): self.setTableViewData(with: clothes)
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
            }
        }
    }

    // MARK: - Defined methods

    func createFooterView() -> UIView {
        itemCountLabel.textColor = .systemGray
        footerContainerView.addSubview(itemCountLabel)

        itemCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(footerContainerView)
        }

        return footerContainerView
    }

    func setTableViewData(with clothes: [Clothing]) {
        if clothes.isEmpty {
            itemCountLabel.text = "0 items"
        }

        dataSource.clothes = clothes
        tableView.hideActivityIndicator()
        tableView.reloadDataWithAnimation()
    }

    func addTableViewData(using clothing: Clothing) {
        dataSource.clothes.insert(clothing, at: 0)
        dataSource.sortClothes()
        tableView.reloadData()
    }

    func editButtonTapped(_ action: UIAction) {
        let folderFormScreen = FolderFormScreen(selectedFolder: folder)
        let destinationScreen = AMNavigationController(rootViewController: folderFormScreen)
        folderFormScreen.delegate = self
        folderFormScreen.isModalInPresentation = true
        present(destinationScreen, animated: true)
    }

    func addButtonTapped(_ action: UIAction) {
        let clothingFormScreen = ClothingFormScreen()
        let destinationScreen = AMNavigationController(rootViewController: clothingFormScreen)
        clothingFormScreen.delegate = self
        clothingFormScreen.isModalInPresentation = true
        present(destinationScreen, animated: true)
    }
}

// MARK: - Data source delegate

extension FolderScreen: ClothesDataSourceDelegate {
    func didUpdateDataSource(_ clothing: [Clothing]) {
        dataSource.sortClothes()
        let count = clothing.count
        itemCountLabel.text = count == 1 ? "1 item" : "\(count) items"
    }

    func errorIsPresented(_ error: AMError) {
        presentErrorAlert(message: error.rawValue)
    }
}

// MARK: - Clothing form delegate

extension FolderScreen: ClothingFormScreenDelegate {
    func didAddNewClothing(_ clothing: Clothing, image: UIImage) {
        guard let id = folder.id else { return }

        FirebaseManager.shared.addClothing(with: clothing, image: image, folderId: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let clothing): self.addTableViewData(using: clothing)
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
            }
        }
    }
}

// MARK: - Folder form delegate

extension FolderScreen: FolderFormScreenDelegate {
    func didUpdateExistingFolder(_ folder: Folder) {
        title = folder.title

        FirebaseManager.shared.updateFolder(folder) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(_): self.tableView.reloadData()
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
            }
        }
    }
}

// MARK: - Table view delegate

extension FolderScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clothing = dataSource.getItem(for: indexPath)
        let clothingScreen = ClothingScreen(clothing: clothing)
        navigationController?.pushViewController(clothingScreen, animated: true)
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
        return UIHelper.favoriteClothingAction(dataSource: dataSource, tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - Search controller

extension FolderScreen: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        dataSource.searchText = ""
        dataSource.filterClothesWithSearchText()
        tableView.reloadDataWithAnimation()
    }
}

extension FolderScreen: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        dataSource.searchText = searchText
        dataSource.filterClothesWithSearchText()
        tableView.reloadDataWithAnimation()
    }
}

// MARK: - Previews

#if DEBUG
struct FolderScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: FolderScreen(folder: Folder.example))
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
