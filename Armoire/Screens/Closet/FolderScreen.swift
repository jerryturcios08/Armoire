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
    let tableView = UITableView()

    let folder = "Dresses"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
    }

    func configureScreen() {
        title = folder
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

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
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ClothingCell.self, forCellReuseIdentifier: ClothingCell.reuseId)
        tableView.rowHeight = 121
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { $0.size.equalTo(view) }
    }

    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        // Show create item screen
    }
}

extension FolderScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClothingCell.reuseId, for: indexPath) as! ClothingCell
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clothingScreen = ClothingScreen()
        navigationController?.pushViewController(clothingScreen, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let containerView = UIView()
        let itemCountLabel = AMBodyLabel(text: "\(4) items", fontSize: 18)
        itemCountLabel.textColor = .systemGray
        containerView.addSubview(itemCountLabel)

        itemCountLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(18)
            make.centerX.equalTo(containerView)
        }

        return containerView
    }
}

#if DEBUG
struct FolderScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: FolderScreen())
        }
    }
}
#endif
