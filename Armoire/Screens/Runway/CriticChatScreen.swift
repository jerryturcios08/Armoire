//
//  CriticChatScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/13/21.
//

import SwiftUI
import UIKit

class CriticChatScreen: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    var messages = [Message]()

    private var criticName: String

    init(criticName: String) {
        self.criticName = criticName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureTableView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle == .light {
            tableView.backgroundColor = .systemGray6
        } else if traitCollection.userInterfaceStyle == .dark {
            tableView.backgroundColor = .black
        }
    }

    func configureScreen() {
        title = criticName
        view.backgroundColor = .systemBackground

        messages = [
            .init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Commodo nulla facilisi nullam vehicula ipsum a arcu. Sit amet justo donec enim diam. Senectus et netus et malesuada fames ac. Ultrices sagittis orci a scelerisque purus semper.", isIncoming: true),
            .init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet facilisis magna etiam tempor orci eu.", isIncoming: false),
            .init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Commodo nulla facilisi nullam vehicula ipsum a arcu. Sit amet justo donec enim diam. Senectus et netus et malesuada fames ac. Ultrices sagittis orci a scelerisque purus semper.", isIncoming: true),
            .init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet facilisis magna etiam tempor orci eu.", isIncoming: true),
            .init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Commodo nulla facilisi nullam vehicula ipsum a arcu. Sit amet justo donec enim diam. Senectus et netus et malesuada fames ac. Ultrices sagittis orci a scelerisque purus semper.", isIncoming: false),
            .init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet facilisis magna etiam tempor orci eu.", isIncoming: true),
            .init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Commodo nulla facilisi nullam vehicula ipsum a arcu. Sit amet justo donec enim diam. Senectus et netus et malesuada fames ac. Ultrices sagittis orci a scelerisque purus semper.", isIncoming: false),
            .init(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet facilisis magna etiam tempor orci eu.", isIncoming: false)
        ]
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseId)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none

        if traitCollection.userInterfaceStyle == .light {
            tableView.backgroundColor = .systemGray6
        } else if traitCollection.userInterfaceStyle == .dark {
            tableView.backgroundColor = .black
        }

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CriticChatScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.set(message: message)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

#if DEBUG
struct CriticChatScreenPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewControllerPreview {
                AMNavigationController(rootViewController: CriticChatScreen(criticName: "@notelena"))
            }
            .ignoresSafeArea(.all, edges: .all)
            UIViewControllerPreview {
                AMNavigationController(rootViewController: CriticChatScreen(criticName: "@notelena"))
            }
            .preferredColorScheme(.dark)
            .ignoresSafeArea(.all, edges: .all)
        }
    }
}
#endif
