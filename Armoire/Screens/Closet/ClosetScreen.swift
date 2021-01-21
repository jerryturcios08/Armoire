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

    var folders = [String]() {
        didSet {
            let count = folders.count
            folderCountLabel.text = count == 1 ? "1 folder" : "\(count) folders"
        }
    }

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
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton

        folders = ["Dresses", "Shoes", "Skirts", "Bottoms"]
    }

    func configureSearchController() {
        let searchController = UISearchController()

        let customFont = UIFont(name: Fonts.quicksandMedium, size: 18)!
        let textAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        let attributedString = NSAttributedString(string: "Search Closet", attributes: textAttributes)
        searchController.searchBar.searchTextField.attributedPlaceholder = attributedString

        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
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

    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        // Show create item screen
    }
}

extension ClosetScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell.reuseId, for: indexPath) as! FolderCell
        let folder = folders[indexPath.row]
        cell.set(folder: folder)
        return cell
    }

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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            folders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

#if DEBUG
struct ClosetScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: ClosetScreen())
        }
    }
}
#endif
