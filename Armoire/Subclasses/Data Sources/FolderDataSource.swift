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
    var filteredFolders = [Folder]()
    weak var delegate: FolderDataSourceDelegate?

    var searchText = ""

    // MARK: - "Getter" methods

    func getItem(for indexPath: IndexPath) -> Folder {
        searchText.isEmpty ? folders[indexPath.row] : filteredFolders[indexPath.row]
    }

    func getItems() -> [Folder] {
        searchText.isEmpty ? folders : filteredFolders
    }

    // MARK: - Utility methods

    func filterFoldersWithSearchText() {
        filteredFolders = folders.filter {
            searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased())
        }
    }

    func sortFolders() {
        folders = folders.sorted { firstItem, secondItem in
            if firstItem.isFavorite == secondItem.isFavorite {
                return firstItem.title < secondItem.title
            }

            return firstItem.isFavorite && !secondItem.isFavorite
        }
    }

    // MARK: - Table view methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.didUpdateDataSource(getItems())
        return getItems().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderCell.reuseId, for: indexPath) as! FolderCell

        cell.set(folder: getItem(for: indexPath))
        delegate?.didUpdateDataSource(getItems())

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedFolder = getItem(for: indexPath)

            FirebaseManager.shared.deleteFolder(selectedFolder) { [weak self] error in
                guard let self = self else { return }
                self.delegate?.errorIsPresented(error)
                return
            }

            if searchText.isEmpty {
                folders.remove(at: indexPath.row)
            } else {
                filteredFolders.remove(at: indexPath.row)

                for (index, folder) in folders.enumerated() {
                    if selectedFolder.id == folder.id {
                        folders.remove(at: index)
                    }
                }
            }

            delegate?.didUpdateDataSource(folders)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
