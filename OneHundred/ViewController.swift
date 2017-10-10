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
    var gridView: UIStackView!
    
    var numberOfRows = 10
    var numberOfColumns = 10
    
    // The model for the gameGrid
    var gameGrid: GameGrid!
    
    private struct Colors {
        static let unselected = UIColor.lightGray
        static let selected = UIColor.red
        static let possible = UIColor.gray
    }
    
    private func setupGridConstraints()
    {
        gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gridView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        gridView.heightAnchor.constraint(equalTo: gridView.widthAnchor).isActive = true
    }
    
    private func setupLayout()
    {
        // Create the gridView
        var cellCount = 0
    
        for _ in 0..<numberOfRows {
            let stackView = UIStackView()
            for _ in 0..<numberOfColumns {
                let button = UIButton()
                button.showsTouchWhenHighlighted = true
                button.backgroundColor = Colors.unselected
                button.accessibilityIdentifier = String(cellCount)
                cellCount += 1
                button.addTarget(self, action: #selector(tapCell(_:)), for: UIControlEvents.touchUpInside)
                stackView.addArrangedSubview(button)
            }
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 5.0
            stackView.contentMode = .redraw
            stackView.translatesAutoresizingMaskIntoConstraints = false
            gridView.addArrangedSubview(stackView)
        }
        
        gridView.axis = .vertical
        gridView.alignment = .fill
        gridView.distribution = .fillEqually
        gridView.spacing = 5.0
        gridView.contentMode = .redraw
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        setupGridConstraints()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Instanciate the model
        gameGrid = GameGrid(withRows: numberOfRows, andColumns: numberOfColumns)!
        
        // instanciate the view
        gridView = UIStackView()
        view.addSubview(gridView)
        
        setupLayout()
    }
    
    @objc func tapCell(_ button: UIButton)
    {
        if let buttonID = button.accessibilityIdentifier {
            if let cell = gameGrid[Int(buttonID)!] {
                button.backgroundColor = cell.isActive ? Colors.unselected : Colors.selected
                cell.isActive = cell.isActive ? false : true
            }
        }
    }
}

