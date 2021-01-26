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
    let runwaysCountLabel = AMBodyLabel(text: "0 runways", fontSize: 18)

    var runways = [String]() {
        didSet {
            let count = runways.count
            runwaysCountLabel.text = count == 1 ? "1 runway" : "\(count) runways"
        }
    }

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

        let addButtonImage = UIImage(systemName: SFSymbol.plus)
        let addButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RunwayCell")

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
            } else if self.runways.contains(runwayName) {
                errorAlert.message = "The runways list already contains this name. Please enter another name."
                self.present(errorAlert, animated: true)
            } else {
                self.runways.insert(runwayName, at: 0)
                self.tableView.reloadDataWithAnimation()
            }
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }
}

extension RunwayListScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runways.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunwayCell", for: indexPath)
        let runway = runways[indexPath.row]
        cell.textLabel?.text = runway
        cell.textLabel?.font = UIFont(name: Fonts.quicksandMedium, size: 17)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            runways.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return createFooterView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let runway = runways[indexPath.row]
        let runwayScreen = AMNavigationController(rootViewController: RunwayScreen(runway: runway))
        runwayScreen.modalPresentationStyle = .fullScreen
        runwayScreen.modalTransitionStyle = .crossDissolve
        present(runwayScreen, animated: true)
    }
}

#if DEBUG
struct RunwayListScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: RunwayListScreen())
        }
    }
}
#endif
