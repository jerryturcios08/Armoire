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

    let sections = ["General", "Support", "Danger"]

    let cells: [[CellType]] = [
        [.navigationCell("Account", nil, AccountScreen()), .navigationCell("Notifications", nil, NotificationsScreen())],
        [.navigationCell("About", nil, AboutScreen()), .navigationCell("Tip Jar", nil, TipJarScreen())],
        [.dangerButtonCell("Log Out", .center)]
    ]

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
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NavigationCell")
        tableView.register(DangerButtonCell.self, forCellReuseIdentifier: DangerButtonCell.reuseId)
        tableView.snp.makeConstraints { $0.size.equalTo(view) }
    }

    func deselectSelectedTableViewRow() {
        guard let index = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: index, animated: true)
    }
}

// MARK: - Table view methods

extension ProfileScreen: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cells[indexPath.section][indexPath.row]

        switch cellType {
        case .dangerButtonCell(let title, let textAlignment):
            let cell = tableView.dequeueReusableCell(withIdentifier: DangerButtonCell.reuseId, for: indexPath) as! DangerButtonCell
            cell.set(title: title, textAlignment: textAlignment)
            return cell
        case .navigationCell(let title, let detail, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = detail
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cells[indexPath.section][indexPath.row]

        switch cellType {
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
