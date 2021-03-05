//
//  SceneDelegate.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import FirebaseAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = AMTabBarController()
        window?.makeKeyAndVisible()

        checkAuthenticatedUser()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        checkAuthenticatedUser()
    }

    func checkAuthenticatedUser() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }

            if user == nil {
                self.window?.rootViewController = LoginScreen()
            }
        }
    }
}
