//
//  StoryboardInstantiable.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 27/11/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
    static var sceneIdentifier: String { get }
    static var storyboard: Storyboard { get }
    static func instantiate() -> Self
}

extension StoryboardInstantiable {
    static var sceneIdentifier: String {
        return String(describing: self)
    }
}

extension StoryboardInstantiable where Self: Coordinable {
    static var sceneIdentifier: String {
        let string = String(describing: self)
        if let genericStartIndex = string.firstIndex(of: "<") {
            return String(string.prefix(upTo: genericStartIndex))
        } else {
            return string
        }
    }
}

extension StoryboardInstantiable where Self: ViewController {
    
    /// Instantiate the View Controller from its Storyboard
    static func instantiate() -> Self {
        let sceneStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle(for: Self.self))
        guard let viewController = sceneStoryboard.instantiateViewController(withIdentifier: sceneIdentifier) as? Self else {
            preconditionFailure("Can't locate the ViewController \(sceneIdentifier) into Storyboard \(storyboard.rawValue)")
        }
        return viewController
    }
}

enum Storyboard: String {
    case main = "Main"
    case game = "Game"
}
