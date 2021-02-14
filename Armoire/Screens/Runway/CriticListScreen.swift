//
//  CriticListScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/13/21.
//

import SwiftUI
import UIKit

class CriticListScreen: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
    }

    func configureScreen() {
        title = "Critics"
        view.backgroundColor = .systemBackground

        let xmarkImage = UIImage(systemName: "xmark.circle")
        let cancelButton = UIBarButtonItem(image: xmarkImage, style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }

    func configureSearchController() {
        let searchController = UISearchController()
        let customFont = UIFont(name: Fonts.quicksandMedium, size: 17)!
        let textAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        let attributedString = NSAttributedString(string: "Search Critics", attributes: textAttributes)

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatCell")

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension CriticListScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        cell.textLabel?.text = "Hello"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationScreen = CriticChatScreen(criticName: "@notelena")
        navigationController?.pushViewController(destinationScreen, animated: true)
    }
}

#if DEBUG
struct CriticListScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: CriticListScreen())
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
