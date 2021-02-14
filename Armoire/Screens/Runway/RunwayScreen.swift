//
//  RunwayScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import SwiftUI
import UIKit

class RunwayScreen: UIViewController {
    // MARK: - Properties

    let tableView = UITableView(frame: .zero, style: .grouped)
    let footerContainerView = UIView()
    let runwaysCountLabel = AMBodyLabel(text: "Loading runways...", fontSize: 18)

    var dataSource = RunwayDataSource()

    // MARK: - Configurations

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureSearchController()
        configureTableView()
        fetchRunways()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectSelectedTableViewRow()
        fetchRunways()
    }

    func configureScreen() {
        title = "Runway"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButtonImage = UIImage(systemName: "plus.circle")
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton

        dataSource.delegate = self
    }

    func configureSearchController() {
        let searchController = UISearchController()
        let customFont = UIFont(name: Fonts.quicksandMedium, size: 17)!
        let textAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        let attributedString = NSAttributedString(string: "Search", attributes: textAttributes)

        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = UIColor.accentColor
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
        tableView.showActivityIndicator()

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func fetchRunways() {
        FirebaseManager.shared.fetchRunways(for: "QePfaCJjbHIOmAZgfgTF") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let runways): self.setTableViewData(with: runways)
            case .failure(let error): self.presentErrorAlert(message: error.rawValue)
            }
        }
    }

    // MARK: - Defined methods

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

    func setTableViewData(with runways: [Runway]) {
        if runways.isEmpty {
            runwaysCountLabel.text = "0 runways"
        }

        dataSource.runways = runways
        tableView.hideActivityIndicator()
        tableView.reloadDataWithAnimation()
    }

    func addTableViewData(using runway: Runway) {
        dataSource.runways.append(runway)
        dataSource.sortRunways()
        tableView.reloadDataWithAnimation()
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
                let runway = Runway(title: runwayName)

                FirebaseManager.shared.createRunway(with: runway, for: "QePfaCJjbHIOmAZgfgTF") { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let runway): self.addTableViewData(using: runway)
                    case .failure(let error): self.presentErrorAlert(message: error.rawValue)
                    }
                }
            }
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }
}

// MARK: - Data source delegate

extension RunwayScreen: RunwayDataSourceDelegate {
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

extension RunwayScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let runway = dataSource.getItem(for: indexPath)
        let canvasScreen = AMNavigationController(rootViewController: CanvasScreen(runway: runway))
        canvasScreen.modalPresentationStyle = .fullScreen
        canvasScreen.modalTransitionStyle = .crossDissolve
        present(canvasScreen, animated: true)
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
        return UIHelper.favoriteRunwayAction(dataSource: dataSource, tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - Search controller

extension RunwayScreen: UISearchControllerDelegate, UISearchResultsUpdating {
    func didDismissSearchController(_ searchController: UISearchController) {
        dataSource.searchText = ""
        dataSource.filterRunwaysWithSearchText()
        tableView.reloadDataWithAnimation()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        dataSource.searchText = text
        dataSource.filterRunwaysWithSearchText()
        tableView.reloadDataWithAnimation()
    }
}

// MARK: - Previews

#if DEBUG
struct RunwayScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: RunwayScreen())
        }
    }
}
#endif
