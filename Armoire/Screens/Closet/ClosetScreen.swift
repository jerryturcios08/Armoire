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
    let tableView = UITableView(frame: .zero, style: .grouped)
    let footerContainerView = UIView()
    let folderCountLabel = AMBodyLabel(text: "0 folders", fontSize: 18)

    var dataSource = FolderDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
    }

    func configureScreen() {
        title = "Closet"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButtonImage = UIImage(systemName: "plus")
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = addButton

        dataSource.delegate = self
        dataSource.folders = ["Dresses", "Shoes", "Skirts", "Bottoms"]
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

    func createFooterView() -> UIView {
        footerContainerView.addSubview(folderCountLabel)
        folderCountLabel.textColor = .systemGray

        folderCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(footerContainerView)
        }

        return footerContainerView
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
    func didUpdateDataSource(_ folders: [String]) {
        let count = folders.count
        folderCountLabel.text = count == 1 ? "1 folder" : "\(count) folders"
    }
}

// MARK: - Create folder delegate

extension ClosetScreen: CreateFolderScreenDelegate {
    func didCreateNewFolder(_ folder: Folder) {
        print(folder.title)
        dataSource.folders.append(folder.title)
        tableView.reloadData()
    }
}

// MARK: - Table view delegate

extension ClosetScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderScreen = FolderScreen()
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
