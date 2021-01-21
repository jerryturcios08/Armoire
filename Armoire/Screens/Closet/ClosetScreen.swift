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

    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        // Show create item screen
    }
}

extension ClosetScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell.reuseId, for: indexPath) as! FolderCell
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
        let containerView = UIView()
        let itemCountLabel = AMBodyLabel(text: "\(4) folders", fontSize: 18)
        itemCountLabel.textColor = .systemGray
        containerView.addSubview(itemCountLabel)

        itemCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(containerView)
        }

        return containerView
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
