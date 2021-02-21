//
//  AccountScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import UIKit

class AccountScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
    
    func configureScreen() {
        title = "Account"
        view.backgroundColor = .systemBackground
    }
}
