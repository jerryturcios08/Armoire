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
    weak var delegate: ClothesDataSourceDelegate?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClothingCell.reuseId, for: indexPath) as! ClothingCell
        let clothing = clothes[indexPath.row]

        cell.set(clothing: clothing)
        delegate?.didUpdateDataSource(clothes)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let clothing = clothes[indexPath.row]

            FirebaseManager.shared.deleteClothing(clothing) { [weak self] error in
                guard let self = self else { return }
                self.delegate?.errorIsPresented(error)
                return
            }

            clothes.remove(at: indexPath.row)
            delegate?.didUpdateDataSource(clothes)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
