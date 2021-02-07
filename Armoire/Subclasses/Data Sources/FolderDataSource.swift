//
//  FolderDataSource.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import UIKit

protocol FolderDataSourceDelegate: class {
    func didUpdateDataSource(_ folders: [Folder])
    func errorIsPresented(_ error: AMError)
}

class FolderDataSource: NSObject, UITableViewDataSource {
    var folders = [Folder]()
    weak var delegate: FolderDataSourceDelegate?

    var searchText = ""

    var filteredFolders: [Folder] {
        folders.filter { searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased()) }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.didUpdateDataSource(searchText.isEmpty ? folders : filteredFolders)
        return searchText.isEmpty ? folders.count : filteredFolders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell.reuseId, for: indexPath) as! FolderCell
        let folder = searchText.isEmpty ? folders[indexPath.row] : filteredFolders[indexPath.row]

        cell.set(folder: folder)
        delegate?.didUpdateDataSource(searchText.isEmpty ? folders : filteredFolders)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let folder = searchText.isEmpty ? folders[indexPath.row] : filteredFolders[indexPath.row]

            FirebaseManager.shared.deleteFolder(folder) { [weak self] error in
                guard let self = self else { return }
                self.delegate?.errorIsPresented(error)
                return
            }

            folders.remove(at: indexPath.row)
            delegate?.didUpdateDataSource(folders)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
