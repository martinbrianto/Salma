//
//  SceneDelegate.swift
//  Salma
//
//  Created by gratianus.brianto on 11/04/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func handleURL(_ url: URL){
        
    }
    
    func navigate(_ deeplink: DeepLink){
        guard let tabBarController = window?.rootViewController as? TabBarViewController else { return }
        
        switch deeplink {
        case .addTransaction:
            tabBarController.handleDeepLink(deeplink)
            if let vc = (tabBarController.selectedViewController as? UINavigationController)?.viewControllers.first {
                let addVC = DetailTransactionViewController(state: .add, viewModel: DetailTransactionViewModel(id: nil))
                vc.navigationController?.pushViewController(addVC, animated: true)
            }
        case .addAutotext:
            if let vc = (tabBarController.selectedViewController as? UINavigationController)?.viewControllers.first {
                let viewController = AutotextAddViewController(state: .add, viewModel: AutotextAddVCViewModel(data: nil))
                vc.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(URLContexts)
        guard let urlToOpen = URLContexts.first?.url else { return }
        
        guard let components = NSURLComponents(url: urlToOpen, resolvingAgainstBaseURL: true),
              let host = components.host
        else {
            print("Invalid URL")
            return
        }
        print("Components \(components)" )
        guard let deepLink = DeepLink(rawValue: host) else {
            print("Deeplink not found: \(host)")
            return
        }
        
        navigate(deepLink)
        
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScence = (scene as? UIWindowScene) else { return }
        
        if UserDefaults.standard.bool(forKey: "didFirstLaunch") == true {
            window = UIWindow(windowScene: windowScence)
            let viewController = TabBarViewController()
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        } else {
            window = UIWindow(windowScene: windowScence)
            let viewController = WelcomeViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

