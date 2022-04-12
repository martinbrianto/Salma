//
//  TabBatViewController.swift
//  Salma
//
//  Created by Gratianus Martin on 4/12/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension TabBarViewController {
    func setup(){
        if #available(iOS 13.0, *) {
           let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithDefaultBackground()
           if #available(iOS 15.0, *) {
              UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
           }
        }
        setViewControllers([setupDashBoardTabBarItem(), setupProductTabBarItem(), setupAutotextTabBarItem(), setupTransactionTabBarItem()], animated: false)
    }
    
    func setupDashBoardTabBarItem() -> UINavigationController {
        let dashboardVC = DashboardViewController(nibName: "DashboardViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: dashboardVC)
        navigationController.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "home"), tag: 0)
        return navigationController
    }
    
    func setupProductTabBarItem() -> UINavigationController {
        let productVC = ProductViewController(nibName: "ProductViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: productVC)
        navigationController.tabBarItem = UITabBarItem(title: "Product", image: UIImage(systemName: "shippingbox.fill"), tag: 1)
        return navigationController
    }
    
    func setupAutotextTabBarItem() -> UINavigationController {
        let autotextVC = AutotextViewController(nibName: "AutotextViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: autotextVC)
        navigationController.tabBarItem = UITabBarItem(title: "Autotext", image: UIImage(systemName: "rectangle.3.offgrid.bubble.left.fill"), tag: 2)
        return navigationController
    }
    
    func setupTransactionTabBarItem() -> UINavigationController {
        let transactionVC = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: transactionVC)
        navigationController.tabBarItem = UITabBarItem(title: "Transaction", image: UIImage(systemName: "newspaper.fill"), tag: 3)
        return navigationController
    }
}
