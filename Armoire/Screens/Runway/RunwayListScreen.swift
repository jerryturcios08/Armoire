//
//  RunwayListScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import SwiftUI
import UIKit

class RunwayListScreen: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    let footerContainerView = UIView()
    let runwaysCountLabel = AMBodyLabel(text: "2 runways", fontSize: 18)

    var dataSource = RunwayDataSource()

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
        title = "Runway"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButtonImage = UIImage(systemName: "plus.circle")
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton

        dataSource.delegate = self
        dataSource.runways = [
            Runway(title: "Wedding Outfit 2021", isFavorite: false, status: .notSharing),
            Runway(title: "Casual Outfit", isFavorite: false, status: .sharing)
        ]
        dataSource.sortRunways()
    }

    func configureSearchController() {
        let searchController = UISearchController()
        let customFont = UIFont(name: Fonts.quicksandMedium, size: 17)!
        let textAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        let attributedString = NSAttributedString(string: "Search", attributes: textAttributes)

        searchController.searchBar.searchTextField.attributedPlaceholder = attributedString
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(RunwayCell.self, forCellReuseIdentifier: RunwayCell.reuseId)
        tableView.rowHeight = 70
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func createFooterView() -> UIView {
        runwaysCountLabel.textColor = .systemGray
        footerContainerView.addSubview(runwaysCountLabel)

        runwaysCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(footerContainerView)
        }

        return footerContainerView
    }

    func deselectSelectedTableViewRow() {
        guard let index = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: index, animated: true)
    }

    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Runway", message: "Please enter the name for this runway.", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.accentColor

        alertController.addTextField { textField in
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .yes
            textField.placeholder = "Runway name"
            textField.tintColor = UIColor.accentColor
        }

        alertController.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] action in
            guard let self = self else { return }
            guard let runwayName = alertController.textFields?[0].text else { return }

            let errorAlert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
            errorAlert.view.tintColor = UIColor.accentColor
            errorAlert.addAction(UIAlertAction(title: "Okay", style: .default))

            if runwayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                errorAlert.message = "The text field was empty. Please try again."
                self.present(errorAlert, animated: true)
            } else if self.dataSource.runways.contains(where: { $0.title == runwayName }) {
                errorAlert.message = "The runways list already contains this name. Please enter another name."
                self.present(errorAlert, animated: true)
            } else {
                let newRunway = Runway(title: runwayName, isFavorite: false, status: .notSharing)
                self.dataSource.runways.append(newRunway)
                self.dataSource.sortRunways()
                self.tableView.reloadDataWithAnimation()
            }
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }
}

// MARK: - Data source delegate

extension RunwayListScreen: RunwayDataSourceDelegate {
    func didUpdateDataSource(_ runways: [Runway]) {
        dataSource.sortRunways()
        let count = runways.count
        runwaysCountLabel.text = count == 1 ? "1 runway" : "\(count) runways"
    }

    func errorIsPresented(_ error: AMError) {
        presentErrorAlert(message: error.rawValue)
    }
}

// MARK: - Table view delegate

extension RunwayListScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let runway = dataSource.getItem(for: indexPath)
        let runwayScreen = AMNavigationController(rootViewController: RunwayScreen(runway: runway.title))
        runwayScreen.modalPresentationStyle = .fullScreen
        runwayScreen.modalTransitionStyle = .crossDissolve
        present(runwayScreen, animated: true)
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
struct RunwayListScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: RunwayListScreen())
        }
    }
}
#endif
