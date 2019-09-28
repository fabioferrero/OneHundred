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
    
    private var shouldShowTutorial: Bool {
        get {
            return Keychain.value(for: .showTutorial) ?? true
        }
        set {
            Keychain.set(value: newValue, for: .showTutorial)
        }
    }
}

// MARK: - GameGridViewController Delegate

extension AppCoordinator: GameGridViewControllerDelegate {
    
    func gameGridViewControllerDidAppear(_ gameGridViewController: GameGridViewController) {
        if shouldShowTutorial {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.presentTutorial(from: gameGridViewController)
            }
            shouldShowTutorial = false
        }
    }
    
    func gameGridViewControllerDidTapOnTutorial(_ gameGridViewController: GameGridViewController) {
        presentTutorial(from: gameGridViewController)
    }
}

extension AppCoordinator {
    
    private func presentTutorial(from viewController: ViewController) {
        let tutorialViewController = TutorialViewController.instantiate()
        tutorialViewController.delegate = self
        viewController.present(tutorialViewController, animated: true)
    }
}

// MARK: - TutorialViewController Delegate

extension AppCoordinator: TutorialViewControllerDelegate {
    
    func tutorialViewControllerDidTapOnClose(_ tutorialViewController: TutorialViewController) {
        tutorialViewController.dismiss(animated: true)
    }
}
