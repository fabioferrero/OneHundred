//
//  ViewController.swift
//  App Architecture
//
//  Created by Fabio Ferrero on 27/11/2018.
//  Copyright © 2018 Fabio Ferrero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

}

extension ViewController {
    var inNavigationController: NavigationController {
        return NavigationController(rootViewController: self)
    }
}
