//
//  AppCoordinator.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 28/11/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var window: UIWindow
    var children = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let gameGridViewController = GameGridViewController.instantiate()
        gameGridViewController.delegate = self
        window.rootViewController = gameGridViewController
    }
}

// MARK: - GameGridViewController Delegate

extension AppCoordinator: GameGridViewControllerDelegate {
    
    func gameGridViewControllerDidAppear(_ gameGridViewController: GameGridViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let tutorialViewController = TutorialViewController.instantiate()
            tutorialViewController.delegate = self
            gameGridViewController.present(tutorialViewController, animated: true)
        }
    }
    
    func gameGridViewControllerDidTapOnTutorial(_ gameGridViewController: GameGridViewController) {
        let tutorialViewController = TutorialViewController.instantiate()
        tutorialViewController.delegate = self
        gameGridViewController.present(tutorialViewController, animated: true)
    }
}

// MARK: - TutorialViewController Delegate

extension AppCoordinator: TutorialViewControllerDelegate {
    
    func tutorialViewControllerDidTapOnClose(_ tutorialViewController: TutorialViewController) {
        tutorialViewController.dismiss(animated: true)
    }
}
