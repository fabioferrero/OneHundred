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
    // The reset button
    var resetButton: UIButton!
    
    // The model for the gameGrid
    var gameGrid: GameGrid!
    
    var numberOfRows = 10
    var numberOfColumns = 10
    
    var isGameStarted = false
    var lastSelectedCell: GridCell?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Instanciate the model
        gameGrid = GameGrid(withRows: numberOfRows, andColumns: numberOfColumns)!
        
        // instanciate the view
        gridView = UIStackView()
        view.addSubview(gridView)
        
        resetButton = UIButton()
        view.addSubview(resetButton)
        
        setupLayout()
    }
    
    private struct Colors {
        static let inactive: UIColor = .lightGray
        static let active: UIColor = .red
        static let possible: UIColor = .orange
        static let used: UIColor = .gray
    }
    
    private func setupGridConstraints()
    {
        gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gridView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        gridView.heightAnchor.constraint(equalTo: gridView.widthAnchor).isActive = true
    }
    
    private func setupResetButtonCostraint()
    {
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetButton.centerYAnchor.constraint(equalTo: gridView.bottomAnchor, constant: 100).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupLayout()
    {
        // Create the gridView
        var cellCount = 0
    
        for _ in 0..<numberOfRows {
            let stackView = UIStackView()
            for _ in 0..<numberOfColumns {
                let button = UIButton()
                button.backgroundColor = Colors.inactive
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
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(UIColor.red, for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = UIColor.red.cgColor
        resetButton.layer.cornerRadius = 25
        resetButton.backgroundColor = UIColor.orange
        resetButton.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        
        setupGridConstraints()
        setupResetButtonCostraint()
    }
    
    private func buttonForCell(_ cell: GridCell) -> UIButton {
        let stackView = gridView.arrangedSubviews[cell.row] as! UIStackView
        let cellButton = stackView.arrangedSubviews[cell.column] as! UIButton
        return cellButton
    }
    
    private func setPossibleCells(for selectedCell: GridCell) {
        let possibleCells = gameGrid.possibleCells(forCell: selectedCell)
        for possibleCell in possibleCells {
            if possibleCell.state == .inactive {
                let cellButton = buttonForCell(possibleCell)
                possibleCell.state = .possible
                cellButton.backgroundColor = Colors.possible
            }
        }
    }

    private func unsetPossibleCells(for selectedCell: GridCell) {
        let possibleCells = gameGrid.possibleCells(forCell: selectedCell)
        for possibleCell in possibleCells {
            if possibleCell.state == .possible {
                let cellButton = buttonForCell(possibleCell)
                possibleCell.state = .inactive
                cellButton.backgroundColor = Colors.inactive
            }
        }
    }
    
    @objc func clearAll() {
        gameGrid.forAllCellsPerform{ $0.state = .inactive }
        isGameStarted = false
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let stackView = gridView.arrangedSubviews[row] as! UIStackView
                let button = stackView.arrangedSubviews[column] as! UIButton
                button.backgroundColor = Colors.inactive
            }
        }
    }
    
    @objc func tapCell(_ button: UIButton)
    {
        guard let buttonID = button.accessibilityIdentifier else {
            print("Button without identifier")
            return
        }
            
        guard let selectedCell = gameGrid.cellAt(sequentialIdentifier: buttonID) else {
            print("Cell not found in grid")
            return
        }
        
        if isGameStarted {
            switch selectedCell.state {
            case .inactive:
                break   // Do nothing
            case .active:
                selectedCell.state = .possible
                button.backgroundColor = Colors.possible
                unsetPossibleCells(for: selectedCell)
            case .possible:
                lastSelectedCell?.state = .used
                buttonForCell(lastSelectedCell!).backgroundColor = Colors.used
                unsetPossibleCells(for: lastSelectedCell!)
                lastSelectedCell = selectedCell
                selectedCell.state = .active
                button.backgroundColor = Colors.active
                setPossibleCells(for: selectedCell)
            case .used:
                break   // Do nothing
            }
        } else {
            gameGrid.forAllCellsPerform{ $0.state = .inactive }
            selectedCell.state = .active
            button.backgroundColor = Colors.active
            setPossibleCells(for: selectedCell)
            lastSelectedCell = selectedCell
            isGameStarted = true
        }
    }
}

