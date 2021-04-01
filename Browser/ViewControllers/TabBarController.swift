//
//  TabBarController.swift
//  Browser
//
//  Created by Sergey Sorokin on 30.03.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
        let webViewController = WebViewController()
        let historyViewController = HistoryViewController()
        webViewController.historyDelegate = historyViewController
        
        viewControllers = [
            createNavController(for: webViewController, title: NSLocalizedString("Browse", comment: ""), image: UIImage(systemName: "globe")!),
            createNavController(for: historyViewController, title: NSLocalizedString("History", comment: ""), image: UIImage(systemName: "book")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
