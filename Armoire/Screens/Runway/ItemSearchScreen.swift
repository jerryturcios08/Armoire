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

private struct SearchObject {
    var name: String
    var clothes: [Clothing]
}

class ItemSearchScreen: UIViewController {
    // MARK: - Properties

    let tableView = UITableView(frame: .zero, style: .grouped)
    let notFoundLabel = AMPrimaryLabel(text: "No clothes were found. Please add clothing items using the closet tab.", fontSize: 20)

    private var searchObjects = [SearchObject]()
    private var filteredSearchObjects = [SearchObject]()
    var searchText = ""

    weak var delegate: ItemSearchScreenDelegate?

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
        configureNotFoundLabel()
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
        tableView.snp.makeConstraints { $0.size.equalTo(view) }
    }

    func configureNotFoundLabel() {
        view.addSubview(notFoundLabel)
        notFoundLabel.textColor = .systemGray
        notFoundLabel.numberOfLines = 0
        notFoundLabel.textAlignment = .center
        notFoundLabel.isHidden = true

        notFoundLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
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

    // MARK: - Defined methods

    func setTableViewData(with foldersDectionary: [String: [Clothing]]) {
        if foldersDectionary.isEmpty {
            UIView.transition(with: self.notFoundLabel, duration: 0.25, options: .transitionCrossDissolve, animations: { [weak self] in
                guard let self = self else { return }
                self.notFoundLabel.isHidden = false
            })
        } else {
            notFoundLabel.isHidden = true

            for (key, value) in foldersDectionary {
                searchObjects.append(SearchObject(name: key, clothes: value))
            }
        }

        tableView.hideActivityIndicator()
        tableView.reloadDataWithAnimation()
    }

    func filterSearchObjectsWithSearchText() {
        filteredSearchObjects = searchObjects.filter {
            searchText.isEmpty ? true :
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.clothes.contains {
                    $0.name.lowercased().contains(searchText.lowercased()) ||
                    $0.brand.lowercased().contains(searchText.lowercased())
                }
        }

        tableView.reloadDataWithAnimation()
    }

    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - Table view methods

extension ItemSearchScreen: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchText.isEmpty ? searchObjects.count : filteredSearchObjects.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchText.isEmpty ? searchObjects[section].clothes.count : filteredSearchObjects[section].clothes.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchText.isEmpty ? searchObjects[section].name : filteredSearchObjects[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClothingCell.reuseId, for: indexPath) as! ClothingCell

        let clothing = searchText.isEmpty ?
            searchObjects[indexPath.section].clothes[indexPath.row] :
            filteredSearchObjects[indexPath.section].clothes[indexPath.row]

        cell.set(clothing: clothing)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.searchController?.dismiss(animated: false)

        let clothing = searchText.isEmpty ?
            searchObjects[indexPath.section].clothes[indexPath.row] :
            filteredSearchObjects[indexPath.section].clothes[indexPath.row]

        delegate?.didSelectClothingItem(clothing)
        dismiss(animated: true)
    }
}

// MARK: - Search controller

extension ItemSearchScreen: UISearchControllerDelegate, UISearchResultsUpdating {
    func didDismissSearchController(_ searchController: UISearchController) {
        searchText = ""
        filterSearchObjectsWithSearchText()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText = text
        filterSearchObjectsWithSearchText()
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
