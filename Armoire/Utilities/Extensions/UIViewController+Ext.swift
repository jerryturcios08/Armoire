//
//  UIViewController+Ext.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/31/21.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.accentColor
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
}
