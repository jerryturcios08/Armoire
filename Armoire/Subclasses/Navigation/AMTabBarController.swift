//
//  AMTabBarController.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import UIKit

class AMTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }

    private func configureTabBar() {
        tabBar.barTintColor = .systemBackground
        tabBar.isTranslucent = false

        viewControllers = [
            createClosetNavigation(),
            createWishlistNavigation(),
            createRunwayNavigation(),
            createProfileNavigation()
        ]
    }

    private func createClosetNavigation() -> AMNavigationController {
        let closetScreen = ClosetScreen()
        let tabBarItem = UITabBarItem(title: "Closet", image: UIImage(systemName: SFSymbol.houseFill), tag: 0)
        closetScreen.tabBarItem = tabBarItem
        configureTextAttributes(for: closetScreen.tabBarItem)

        return AMNavigationController(rootViewController: closetScreen)
    }

    private func createProfileNavigation() -> AMNavigationController {
        let profileScreen = ProfileScreen()
        let tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: SFSymbol.personFill), tag: 1)
        profileScreen.tabBarItem = tabBarItem
        configureTextAttributes(for: profileScreen.tabBarItem)

        return AMNavigationController(rootViewController: profileScreen)
    }

    private func createRunwayNavigation() -> AMNavigationController {
        let runwayScreen = RunwayScreen()
        runwayScreen.title = "Runway"
        runwayScreen.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        configureTextAttributes(for: runwayScreen.tabBarItem)

        return AMNavigationController(rootViewController: runwayScreen)
    }

    private func createWishlistNavigation() -> AMNavigationController {
        let wishlistScreen = WishlistScreen()
        wishlistScreen.title = "Wishlist"
        wishlistScreen.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 3)
        configureTextAttributes(for: wishlistScreen.tabBarItem)

        return AMNavigationController(rootViewController: wishlistScreen)
    }

    private func configureTextAttributes(for item: UITabBarItem) {
        let textAttributes = [NSAttributedString.Key.font: UIFont(name: Fonts.quicksandSemiBold, size: 10)]
        item.setTitleTextAttributes(textAttributes as [NSAttributedString.Key : Any], for: .normal)
    }
}
