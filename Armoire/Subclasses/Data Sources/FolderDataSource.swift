//
//  FolderDataSource.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import UIKit

protocol FolderDataSourceDelegate: class {
    func didUpdateDataSource(_ folders: [String])
}

class FolderDataSource: NSObject, UITableViewDataSource {
    var folders = [String]()
    weak var delegate: FolderDataSourceDelegate?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell.reuseId, for: indexPath) as! FolderCell
        let folder = folders[indexPath.row]

        cell.set(folder: folder)
        delegate?.didUpdateDataSource(folders)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            folders.remove(at: indexPath.row)
            delegate?.didUpdateDataSource(folders)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
