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
        viewControllers = [ createClosetNavigation(), createRunwayNavigation(), createProfileNavigation() ]
    }

    private func createClosetNavigation() -> AMNavigationController {
        let closetScreen = ClosetScreen()
        closetScreen.tabBarItem = UITabBarItem(title: "Closet", image: UIImage(systemName: SFSymbol.folder), selectedImage: UIImage(systemName: SFSymbol.folderFill))
        configureTextAttributes(for: closetScreen.tabBarItem)

        return AMNavigationController(rootViewController: closetScreen)
    }

    private func createRunwayNavigation() -> AMNavigationController {
        let runwayScreen = RunwayScreen()
        runwayScreen.tabBarItem = UITabBarItem(title: "Runway", image: UIImage(systemName: SFSymbol.binoculars), selectedImage: UIImage(systemName: SFSymbol.binocularsFill))
        configureTextAttributes(for: runwayScreen.tabBarItem)

        return AMNavigationController(rootViewController: runwayScreen)
    }

    private func createProfileNavigation() -> AMNavigationController {
        let profileScreen = ProfileScreen()
        profileScreen.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: SFSymbol.person), selectedImage: UIImage(systemName: SFSymbol.personFill))
        configureTextAttributes(for: profileScreen.tabBarItem)

        return AMNavigationController(rootViewController: profileScreen)
    }

    private func configureTextAttributes(for item: UITabBarItem) {
        let textAttributes = [NSAttributedString.Key.font: UIFont(name: Fonts.quicksandSemiBold, size: 10)]
        item.setTitleTextAttributes(textAttributes as [NSAttributedString.Key : Any], for: .normal)
    }
}
