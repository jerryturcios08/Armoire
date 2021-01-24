//
//  UIStackView+Ext.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/24/21.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
