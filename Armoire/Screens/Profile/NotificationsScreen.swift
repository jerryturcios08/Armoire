//
//  NotificationsScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/20/21.
//

import UIKit

class NotificationsScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

    func configureScreen() {
        title = "Notifications"
        view.backgroundColor = .systemBackground
    }
}
