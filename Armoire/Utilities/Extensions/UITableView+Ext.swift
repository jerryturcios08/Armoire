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
}
