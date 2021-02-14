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
    var chats = [Chat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectSelectedTableViewRow()
    }

    func configureScreen() {
        title = "Critics"
        view.backgroundColor = .systemBackground

        let xmarkImage = UIImage(systemName: "xmark.circle")
        let cancelButton = UIBarButtonItem(image: xmarkImage, style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton

        chats = [
            .init(
                critic: User(firstName: "Jane", lastName: "Smith", email: "jane.smith@gmail.com", username: "@notjane"),
                messages: [.init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Commodo nulla facilisi nullam vehicula ipsum a arcu. Sit amet justo donec enim diam. Senectus et netus et malesuada fames ac. Ultrices sagittis orci a scelerisque purus semper", isIncoming: true)]
            ),
            .init(
                critic: User(firstName: "Ashley", lastName: "Wonders", email: "ashley.wonders@gmail.com", username: "@ashh"),
                messages: [.init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Commodo nulla facilisi nullam vehicula ipsum a arcu. Sit amet justo donec enim diam. Senectus et netus et malesuada fames ac. Ultrices sagittis orci a scelerisque purus semper", isIncoming: false)]
            )
        ]
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
        tableView.register(CriticChatCell.self, forCellReuseIdentifier: CriticChatCell.reuseId)
        tableView.rowHeight = 100
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func deselectSelectedTableViewRow() {
        guard let index = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: index, animated: true)
    }

    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension CriticListScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CriticChatCell.reuseId, for: indexPath) as! CriticChatCell
        let chat = chats[indexPath.row]
        cell.set(chat: chat)
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
