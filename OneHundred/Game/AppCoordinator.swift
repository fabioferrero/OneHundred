//
//  AppCoordinator.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 28/11/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import Foundation

final class AppCoordinator: Coordinator {
    var navigationController: NavigationController
    var children = [Coordinator]()
    
    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let landingPageViewController = GameGridViewController.instantiate()
        navigationController.pushViewController(landingPageViewController, animated: false)
    }
}
