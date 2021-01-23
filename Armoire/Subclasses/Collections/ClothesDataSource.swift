//
//  ClothesDataSource.swift
//  Armoire
//
//  Created by Jerry Turcios on 1/23/21.
//

import UIKit

protocol ClothesDataSourceDelegate: class {
    func didUpdateDataSource(_ clothing: [String])
}

class ClothesDataSource: NSObject, UITableViewDataSource {
    var clothes = [String]()
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
            clothes.remove(at: indexPath.row)
            delegate?.didUpdateDataSource(clothes)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
