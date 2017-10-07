//
//  ViewController.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 07/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cellsGrid: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give at each cell/button an unique ID
        
        var buttonCounter = 0
        
        guard let stackViews = cellsGrid.arrangedSubviews as? [UIStackView] else {
            print("stackViews extraction problem")
            return
        }
        for stackView in stackViews {
            guard let buttons = stackView.arrangedSubviews as? [UIButton] else {
                print("buttons extraction problem")
                return
            }
            for button in buttons {
                button.accessibilityIdentifier = String(buttonCounter)
                buttonCounter += 1
            }
        }
    }
    
    @IBAction func tapCell(_ cell: UIButton) {
    }
    
    
}

