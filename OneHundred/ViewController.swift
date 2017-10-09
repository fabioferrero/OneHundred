//
//  ViewController.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 07/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // The cell grid composed by one hundred buttons
    @IBOutlet weak var cellsGrid: UIStackView!
    
    // The model for the gameGrid
    let gameGrid = GameGrid(withRows: 10, andColumns: 10)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellCount = 0
        
        for stackView in cellsGrid.arrangedSubviews as! [UIStackView] {
            for button in stackView.arrangedSubviews as! [UIButton] {
                button.showsTouchWhenHighlighted = true
                button.accessibilityIdentifier = String(cellCount)
                cellCount += 1
            }
        }
    }
    
    @IBAction func tapCell(_ button: UIButton)
    {
        //button.backgroundColor = .red
        if let buttonID = button.accessibilityIdentifier {
            print(buttonID)
        }
    }
    
    
}

