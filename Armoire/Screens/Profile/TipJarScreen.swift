//
//  TipJarScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import UIKit

class TipJarScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

    func configureScreen() {
        title = "Tip Jar"
        view.backgroundColor = .systemBackground
    }
}
