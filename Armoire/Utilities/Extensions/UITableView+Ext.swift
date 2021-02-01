//
//  UITableView+Ext.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/24/21.
//

import UIKit

extension UITableView {
    func reloadDataWithAnimation() {
        DispatchQueue.main.async {
            UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.reloadData()
            })
        }
    }

    func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let activityView = UIActivityIndicatorView(style: .large)
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.backgroundView = nil
        }
    }
}
