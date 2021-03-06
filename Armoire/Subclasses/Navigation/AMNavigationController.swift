//
//  AMNavigationController.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import UIKit

class AMNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()

        let largeTitleFont = UIFont(name: Fonts.quicksandBold, size: 34)!
        let smallTitleFont = UIFont(name: Fonts.quicksandBold, size: 17)!

        navigationBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.font: largeTitleFont]
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: smallTitleFont]

        navigationBar.standardAppearance = navigationBarAppearance
    }
}
