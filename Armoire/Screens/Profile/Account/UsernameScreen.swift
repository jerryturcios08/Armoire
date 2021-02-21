//
//  UsernameScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import UIKit

class UsernameScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

    func configureScreen() {
        title = "Change Username"
        view.backgroundColor = .systemBackground
    }
}
