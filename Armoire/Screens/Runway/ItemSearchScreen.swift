//
//  ItemSearchScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/10/21.
//

import SwiftUI
import UIKit

protocol ItemSearchScreenDelegate: class {
    func didSelectClothingItem(_ clothing: Clothing)
}

class ItemSearchScreen: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    let footerContainerView = UIView()
    let itemCountLabel = AMBodyLabel(text: "Loading items...", fontSize: 18)

    var folders = [String]()
    var clothes = [[Clothing]]()

    weak var delegate: ItemSearchScreenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
        fetchAllClothes()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .white
            tableView.backgroundColor = .white
        } else if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
            tableView.backgroundColor = .black
        }
    }

    func configureScreen() {
        title = "Clothing Item Search"

        let xmarkImage = UIImage(systemName: "xmark.circle")
        let cancelButton = UIBarButtonItem(image: xmarkImage, style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
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

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ClothingCell.self, forCellReuseIdentifier: ClothingCell.reuseId)
        tableView.rowHeight = 121
        tableView.separatorStyle = .none
        tableView.showActivityIndicator()

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func fetchAllClothes() {
        FirebaseManager.shared.fetchAllClothes(for: "QePfaCJjbHIOmAZgfgTF") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let foldersDictionary): self.setTableViewData(with: foldersDictionary)
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
            }
        }
    }

    func createFooterView() -> UIView {
        itemCountLabel.textColor = .systemGray
        footerContainerView.addSubview(itemCountLabel)

        itemCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(footerContainerView)
        }

        return footerContainerView
    }

    func setTableViewData(with foldersDectionary: [String: [Clothing]]) {
        if foldersDectionary.isEmpty {
            itemCountLabel.text = "0 items"
        }

        for (key, value) in foldersDectionary {
            folders.append(key)
            clothes.append(value)
        }

        tableView.hideActivityIndicator()
        tableView.reloadDataWithAnimation()
    }

    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - Table view methods

extension ItemSearchScreen: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return folders.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothes[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return folders[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClothingCell.reuseId, for: indexPath) as! ClothingCell
        let clothing = clothes[indexPath.section][indexPath.row]
        cell.set(clothing: clothing)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectClothingItem(clothes[indexPath.section][indexPath.row])
        dismiss(animated: true)
    }
}

// MARK: - Search controller

extension ItemSearchScreen: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

// MARK: - Previews

#if DEBUG
struct ItemSearchScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview { AMNavigationController(rootViewController: ItemSearchScreen()) }
            .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
