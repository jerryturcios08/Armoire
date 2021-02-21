//
//  AboutScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import UIKit

class AboutScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

    func configureScreen() {
        title = "About"
        view.backgroundColor = .systemBackground
    }
}
