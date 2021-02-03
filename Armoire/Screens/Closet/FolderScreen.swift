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

        guard let id = folder.id else { return }

        FirebaseManager.shared.fetchClothes(for: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let clothes): self.setTableViewData(with: clothes)
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
            }
        }
    }

    func configureScreen() {
        title = folder.title
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        let addButtonImage = UIImage(systemName: SFSymbol.plus)
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(addButtonTapped))
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
        tableView.register(ClothingCell.self, forCellReuseIdentifier: ClothingCell.reuseId)
        tableView.rowHeight = 121
        tableView.separatorStyle = .none
        tableView.showActivityIndicator()

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
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
        tableView.reloadData()
    }

    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        let addClothingScreen = AddClothingScreen()
        let destinationScreen = AMNavigationController(rootViewController: addClothingScreen)
        addClothingScreen.delegate = self
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
    }
}

// MARK: - Data source delegate

extension FolderScreen: ClothesDataSourceDelegate {
    func didUpdateDataSource(_ clothing: [Clothing]) {
        let count = clothing.count
        itemCountLabel.text = count == 1 ? "1 item" : "\(count) items"
    }

    func errorIsPresented(_ error: AMError) {
        presentErrorAlert(message: error.rawValue)
    }
}

// MARK: - Add clothing delegate

extension FolderScreen: AddClothingScreenDelegate {
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

// MARK: - Table view delegate

extension FolderScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clothing = dataSource.clothes[indexPath.row]
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
        let action = UIContextualAction(style: .normal, title: "Favorite") { action, view, completionHandler in
            completionHandler(true)
        }

        action.backgroundColor = .systemYellow
        action.image = UIImage(systemName: SFSymbol.starFill)

        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - Previews

#if DEBUG
struct FolderScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: FolderScreen(folder: Folder.example))
        }
    }
}
#endif
