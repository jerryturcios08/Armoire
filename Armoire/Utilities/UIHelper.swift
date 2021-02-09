//
//  UIHelper.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import UIKit

enum UIHelper {
    static func favoriteClothingAction(dataSource: ClothesDataSource, tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let clothing = dataSource.getItem(for: indexPath)

        let actionColor = clothing.isFavorite ? UIColor.systemGray : UIColor.systemYellow
        let actionTitle = clothing.isFavorite ? "Unfavorite" : "Favorite"
        let actionImage = clothing.isFavorite ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")

        let action = UIContextualAction(style: .normal, title: actionTitle) { action, view, completionHandler in
            if dataSource.searchText.isEmpty {
                dataSource.clothes[indexPath.row].isFavorite.toggle()
            } else {
                dataSource.filteredClothes[indexPath.row].isFavorite.toggle()
            }

            let updatedClothing = dataSource.getItem(for: indexPath)
            
            dataSource.sortClothes()
            tableView.reloadDataWithAnimation()

            FirebaseManager.shared.toggleFavoriteClothing(updatedClothing) { result in
                switch result {
                case .success(_): break
                case .failure(let error): fatalError(error.rawValue)
                }
            }

            completionHandler(true)
        }

        action.backgroundColor = actionColor
        action.image = actionImage

        return UISwipeActionsConfiguration(actions: [action])
    }

    static func favoriteFolderAction(dataSource: FolderDataSource, tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let folder = dataSource.getItem(for: indexPath)

        let actionColor = folder.isFavorite ? UIColor.systemGray : UIColor.systemYellow
        let actionTitle = folder.isFavorite ? "Unfavorite" : "Favorite"
        let actionImage = folder.isFavorite ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")

        let action = UIContextualAction(style: .normal, title: actionTitle) { action, view, completionHandler in
            if dataSource.searchText.isEmpty {
                dataSource.folders[indexPath.row].isFavorite.toggle()
            } else {
                dataSource.filteredFolders[indexPath.row].isFavorite.toggle()
            }

            let updatedFolder = dataSource.getItem(for: indexPath)

            dataSource.sortFolders()
            tableView.reloadDataWithAnimation()

            FirebaseManager.shared.updateFolder(updatedFolder) { result in
                switch result {
                case .success(_): break
                case .failure(let error): fatalError(error.rawValue)
                }
            }

            completionHandler(true)
        }

        action.backgroundColor = actionColor
        action.image = actionImage

        return UISwipeActionsConfiguration(actions: [action])
    }
}
