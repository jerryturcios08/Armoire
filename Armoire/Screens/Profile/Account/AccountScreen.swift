//
//  AccountScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import SwiftUI
import UIKit

class AccountScreen: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)

    let sections = ["Avatar", "General", "Danger"]
    var cells = [[CellType]]()

    private var user: User

    init(user: User) {
        self.user = user
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectSelectedTableViewRow()
    }

    func configureScreen() {
        title = "Account"
        view.backgroundColor = .systemBackground
    }

    func configureTableView() {
        cells = [
            [.avatarCell],
            [
                .navigationCell("Username", user.username, UsernameScreen()),
                .navigationCell("Email", user.email, EmailScreen()),
                .navigationCell("Password", nil, PasswordScreen())
            ],
            [.dangerButtonCell("Delete Account")]
        ]

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AvatarCell.self, forCellReuseIdentifier: AvatarCell.reuseId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DangerButtonCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NavigationCell")
        tableView.snp.makeConstraints { $0.size.equalTo(view) }
    }

    func deselectSelectedTableViewRow() {
        guard let index = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: index, animated: true)
    }

    func deleteAccountButtonTapped() {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to delete your account? All account data will be erased and this action is irreversible.", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.accentColor

        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.presentErrorAlert(message: "ACCOUNT DELETED!")
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }
}

// MARK: - Table view methods

extension AccountScreen: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cells[indexPath.section][indexPath.row]
        let customFont = UIFontMetrics.default.scaledFont(for: UIFont(name: Fonts.quicksandMedium, size: 17)!)

        switch cellType {
        case .avatarCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: AvatarCell.reuseId, for: indexPath) as! AvatarCell
            cell.set(image: UIImage(named: "CriticAvatar")!)
            return cell
        case .dangerButtonCell(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "DangerButtonCell", for: indexPath)

            cell.textLabel?.text = title
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.font = customFont
            cell.selectionStyle = .none

            return cell
        case .navigationCell(let title, let detail, _):
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "NavigationCell")

            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = title
            cell.textLabel?.font = customFont
            cell.detailTextLabel?.text = detail
            cell.detailTextLabel?.font = customFont

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cells[indexPath.section][indexPath.row]

        switch cellType {
        case .avatarCell: navigationController?.pushViewController(AvatarScreen(), animated: true)
        case .dangerButtonCell(_): deleteAccountButtonTapped()
        case .navigationCell(_, _, let destination): navigationController?.pushViewController(destination, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 84 : 44
    }
}

// MARK: - Previews

#if DEBUG
struct AccountScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: AccountScreen(user: User.example))
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
