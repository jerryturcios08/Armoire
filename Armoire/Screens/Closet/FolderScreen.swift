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
    let tableView = UITableView(frame: .zero, style: .grouped)
    let footerContainerView = UIView()
    let itemCountLabel = AMBodyLabel(text: "0 items", fontSize: 18)

    private var folder: String
    var dataSource = ClothesDataSource()

    init(folder: String) {
        self.folder = folder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        let addButtonImage = UIImage(systemName: SFSymbol.plus)
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton

        dataSource.delegate = self
        dataSource.clothes = ["Pink Dress 1", "Pink Dress 2", "Pink Dress 3", "Pink Dress 4"]
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

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
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

    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        let destinationScreen = AMNavigationController(rootViewController: AddClothingScreen())
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
    }
}

// MARK: - Data source delegate

extension FolderScreen: ClothesDataSourceDelegate {
    func didUpdateDataSource(_ clothing: [String]) {
        let count = clothing.count
        itemCountLabel.text = count == 1 ? "1 item" : "\(count) items"
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
}

// MARK: - Previews

#if DEBUG
struct FolderScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: FolderScreen(folder: "Dresses"))
        }
    }
}
#endif
