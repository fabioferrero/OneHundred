//
//  Coordinator.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 28/11/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var window: UIWindow { get set }
    var children: [Coordinator] { get set }
    func start()
}

// MARK: - CoordinableViewController

class CoordinableViewController<C: Coordinator>: ViewController {
    weak var coordinator: C?
}

// MARK: - Coordinable

protocol Coordinable: class {
    associatedtype Coordinator
    var coordinator: Coordinator? { get set }
}

extension Coordinator {
    
//    func build<T: CoordinableViewController<Self>>(configure: ((T) -> Void)? = nil) -> T {
//        let viewController = T()
//        viewController.coordinator = self
//        configure?(viewController)
//        return viewController
//    }
//
//    func build<T: CoordinableViewController<Self>>(configure: ((T) -> Void)? = nil) -> T where T: StoryboardInstantiable {
//        let viewController = T.instantiate()
//        viewController.coordinator = self
//        configure?(viewController)
//        return viewController
//    }
    
    func build<T: ViewController>() -> T where T: StoryboardInstantiable, T: Coordinable, Self == T.Coordinator {
        let viewController = T.instantiate()
        viewController.coordinator = self
        return viewController
    }
}
