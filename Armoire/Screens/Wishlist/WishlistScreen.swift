//
//  WishlistScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import UIKit

class WishlistScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }

    func configureScreen() {
        title = "Wishlist"
        view.backgroundColor = .systemBackground
    }
}
