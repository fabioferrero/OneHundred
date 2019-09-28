//
//  TutorialViewController.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 06/01/2019.
//  Copyright © 2019 fabfer_dev. All rights reserved.
//

import UIKit

protocol TutorialViewControllerDelegate: class {
    func tutorialViewControllerDidTapOnClose(_ tutorialViewController: TutorialViewController)
}

final class TutorialViewController: ViewController {
    
    weak var delegate: TutorialViewControllerDelegate?
    
    // MARK: - Actions
    
    @IBAction func userDidTapOnClose(_ button: Button) {
        delegate?.tutorialViewControllerDidTapOnClose(self)
    }
}

extension TutorialViewController: StoryboardInstantiable {
    static var storyboard: Storyboard {
        return .game
    }
}
