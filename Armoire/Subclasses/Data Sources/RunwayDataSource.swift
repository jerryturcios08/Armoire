//
//  RunwayDataSource.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/9/21.
//

import UIKit

protocol RunwayDataSourceDelegate: class {
    func didUpdateDataSource(_ runways: [Runway])
    func errorIsPresented(_ error: AMError)
}

class RunwayDataSource: NSObject, UITableViewDataSource {
    var runways = [Runway]()
    var filteredRunways = [Runway]()
    weak var delegate: RunwayDataSourceDelegate?

    var searchText = ""

    // MARK: - "Getter" methods

    func getItem(for indexPath: IndexPath) -> Runway {
        searchText.isEmpty ? runways[indexPath.row] : filteredRunways[indexPath.row]
    }

    func getItems() -> [Runway] {
        searchText.isEmpty ? runways : filteredRunways
    }

    // MARK: - Utility methods

    func filterRunwaysWithSearchText() {
        filteredRunways = runways.filter {
            searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased())
        }
    }

    func sortRunways() {
        runways = runways.sorted { firstItem, secondItem in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: RunwayCell.reuseId, for: indexPath) as! RunwayCell
        
        cell.set(runway: getItem(for: indexPath))
        delegate?.didUpdateDataSource(getItems())

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedRunway = getItem(for: indexPath)

            FirebaseManager.shared.deleteRunway(selectedRunway) { [weak self] error in
                guard let self = self else { return }
                self.delegate?.errorIsPresented(error)
                return
            }

            if searchText.isEmpty {
                runways.remove(at: indexPath.row)
            } else {
                filteredRunways.remove(at: indexPath.row)

                for (index, runway) in runways.enumerated() {
                    if selectedRunway.id == runway.id {
                        runways.remove(at: index)
                    }
                }
            }

            delegate?.didUpdateDataSource(runways)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
