//
//  UIHelper.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import UIKit

enum UIHelper {
    static func favoriteFolderAction(dataSource: FolderDataSource, tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let folder = dataSource.folders[indexPath.row]

        let actionColor = folder.isFavorite ? UIColor.systemGray : UIColor.systemYellow
        let actionTitle = folder.isFavorite ? "Unfavorite" : "Favorite"
        let actionImage = folder.isFavorite ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")

        let action = UIContextualAction(style: .normal, title: actionTitle) { action, view, completionHandler in
            dataSource.folders[indexPath.row].isFavorite.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            let updatedFolder = dataSource.folders[indexPath.row]

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
