//
//  EmailScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import UIKit

class EmailScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

    func configureScreen() {
        title = "Change Email"
        view.backgroundColor = .systemBackground
    }
}
