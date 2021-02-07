//
//  ClothesDataSource.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/23/21.
//

import UIKit

protocol ClothesDataSourceDelegate: class {
    func didUpdateDataSource(_ clothing: [Clothing])
    func errorIsPresented(_ error: AMError)
}

class ClothesDataSource: NSObject, UITableViewDataSource {
    var clothes = [Clothing]()
    var filteredClothes = [Clothing]()
    weak var delegate: ClothesDataSourceDelegate?

    var searchText = ""

    // MARK: "Getter" methods

    func getItem(for indexPath: IndexPath) -> Clothing {
        searchText.isEmpty ? clothes[indexPath.row] : filteredClothes[indexPath.row]
    }

    func getItems() -> [Clothing] {
        searchText.isEmpty ? clothes : filteredClothes
    }

    // MARK: - Search methods

    func filterObjectsWithSearchText() {
        filteredClothes = clothes.filter {
            searchText.isEmpty ? true :
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.brand.lowercased().contains(searchText.lowercased()) ||
                $0.size?.lowercased().contains(searchText.lowercased()) != nil ||
                $0.material?.lowercased().contains(searchText.lowercased()) != nil
        }
    }

    // MARK: - Table view methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.didUpdateDataSource(getItems())
        return getItems().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClothingCell.reuseId, for: indexPath) as! ClothingCell

        cell.set(clothing: getItem(for: indexPath))
        delegate?.didUpdateDataSource(getItems())

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedClothing = getItem(for: indexPath)

            FirebaseManager.shared.deleteClothing(selectedClothing) { [weak self] error in
                guard let self = self else { return }
                self.delegate?.errorIsPresented(error)
                return
            }

            if searchText.isEmpty {
                clothes.remove(at: indexPath.row)
            } else {
                filteredClothes.remove(at: indexPath.row)

                for (index, clothing) in clothes.enumerated() {
                    if selectedClothing.id == clothing.id {
                        clothes.remove(at: index)
                    }
                }
            }

            delegate?.didUpdateDataSource(clothes)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
