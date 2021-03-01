//
//  ProfileScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import SwiftUI
import UIKit

class ProfileScreen: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)

    var cells = [[CellType]]()

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
        title = "Profile"
        view.backgroundColor = .systemBackground
    }

    func configureTableView() {
        cells = [
            [.navigationCell("Account", nil, AccountScreen(user: User.example)), .navigationCell("Notifications", nil, NotificationsScreen())],
            [.navigationCell("About", nil, AboutScreen()), .navigationCell("Tip Jar", nil, TipJarScreen())],
            [.dangerButtonCell("Log Out")]
        ]

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DangerButtonCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NavigationCell")
        tableView.snp.makeConstraints { $0.size.equalTo(view) }
    }

    func deselectSelectedTableViewRow() {
        guard let index = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: index, animated: true)
    }

    func logOutButtonTapped() {
        presentErrorAlert(message: "Logged out!")
    }
}

// MARK: - Table view methods

extension ProfileScreen: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cells[indexPath.section][indexPath.row]
        let customFont = UIFontMetrics.default.scaledFont(for: UIFont(name: Fonts.quicksandMedium, size: 17)!)

        switch cellType {
        case .dangerButtonCell(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "DangerButtonCell", for: indexPath)

            cell.textLabel?.text = title
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.font = customFont
            cell.selectionStyle = .none

            return cell
        case .navigationCell(let title, let detail, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationCell", for: indexPath)

            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = title
            cell.textLabel?.font = customFont
            cell.detailTextLabel?.text = detail
            cell.detailTextLabel?.font = customFont

            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cells[indexPath.section][indexPath.row]

        switch cellType {
        case .dangerButtonCell(_): logOutButtonTapped()
        case .navigationCell(_, _, let destination):
            navigationController?.pushViewController(destination, animated: true)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? ProfileHeaderView(user: User.example) : nil
    }
}

// MARK: - Previews

#if DEBUG
struct ProfileScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: ProfileScreen())
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
