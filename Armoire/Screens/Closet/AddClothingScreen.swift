//
//  AddClothingScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/21/21.
//

import SwiftUI
import UIKit

class AddClothingScreen: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureTableView()
    }

    func configureScreen() {
        title = "Add Clothing"
        view.backgroundColor = .systemBackground

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissScreen))
        navigationItem.leftBarButtonItem = cancelButton

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.allowsSelection = false

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func doneButtonTapped() {
        dismissScreen()
    }

    @objc func dismissScreen() {
        dismiss(animated: true)
    }
}

// MARK: - Table view methods

extension AddClothingScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Label"
        return cell
    }
}

// MARK: - Previews

#if DEBUG
struct AddClothingScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: AddClothingScreen())
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
#endif
