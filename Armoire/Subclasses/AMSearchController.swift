//
//  AMSearchController.swift
//  Armoire
//
//  Created by Jerry Turcios on 1/20/21.
//

import UIKit

class AMSearchController: UISearchController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }

    private func configureController() {
        let customFont = UIFont(name: Fonts.quicksandMedium, size: 18)!
        let textAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        let attributedString = NSAttributedString(string: "Search Closet", attributes: textAttributes)

        searchBar.searchTextField.attributedPlaceholder = attributedString
        obscuresBackgroundDuringPresentation = false
    }
}
