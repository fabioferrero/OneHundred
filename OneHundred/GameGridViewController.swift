//
//  ViewController.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 07/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import UIKit

class GameGridViewController: UIViewController
{
    // MARK: - View
    
    // The cell grid composed by one hundred buttons
    var gridView: UIStackView!
    // The reset button
    var resetButton: UIButton!
    // The score label
    var scoreLabel: UILabel!
    
    // MARK: - Model
    
    // The model for the grid
    var gameGrid: GameGrid!
    
    // MARK: - Controller
    
    var numberOfRows = 10
    var numberOfColumns = 10
    
    var isGameStarted = false
    var lastSelectedCell: GridCell? {
        return selectionHistory.last
    }
    
    var selectionHistory = [GridCell]()
    
    private var scoreCounter: Int = 0 {
        didSet {
            scoreLabel.text = String(scoreCounter)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Instanciate the model
        gameGrid = GameGrid(withRows: numberOfRows, andColumns: numberOfColumns)!
        
        // Instanciate the view
        setupLayoutAndConstraints()
    }
    
    private struct Colors {
        static let inactive: UIColor = .lightGray
        static let active: UIColor = .red
        static let possible: UIColor = .orange
        static let used: UIColor = .gray
    }
    
    // MARK: - View's Constraints
    
    private func setupGridConstraints()
    {
        gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gridView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        gridView.heightAnchor.constraint(equalTo: gridView.widthAnchor).isActive = true
    }
    
    private func setupResetButtonCostraints()
    {
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetButton.centerYAnchor.constraint(equalTo: gridView.bottomAnchor, constant: 100).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupScoreLabelConstraints()
    {
        scoreLabel.leadingAnchor.constraint(equalTo: gridView.leadingAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: gridView.topAnchor, constant: -80).isActive = true
    }
    
    // MARK: - View's Layout
    
    private func setupGridLayout()
    {
        gridView = UIStackView()
        view.addSubview(gridView)
        
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
    }
    
    private func setupResetButtonLayout()
    {
        resetButton = UIButton()
        view.addSubview(resetButton)
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(UIColor.red, for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = UIColor.red.cgColor
        resetButton.layer.cornerRadius = 25
        resetButton.backgroundColor = UIColor.orange
        resetButton.addTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)
    }
    
    private func setupScoreLabelLayout()
    {
        scoreLabel = UILabel()
        view.addSubview(scoreLabel)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    private func setupLayoutAndConstraints()
    {
        // Setup Layouts
        setupGridLayout()
        setupResetButtonLayout()
        setupScoreLabelLayout()
        
        // Setup Contraints
        setupGridConstraints()
        setupResetButtonCostraints()
        setupScoreLabelConstraints()
    }
    
    // MARK: -
    
    /**
     Returns the button in the view that is related to the given cell in the model.
     */
    private func buttonForCell(_ cell: GridCell) -> UIButton {
        let stackView = gridView.arrangedSubviews[cell.row] as! UIStackView
        let cellButton = stackView.arrangedSubviews[cell.column] as! UIButton
        return cellButton
    }
    
    /**
     Update the view for all the possible cells with respect the given selected cell.
     */
    private func setPossibleCells(for selectedCell: GridCell) {
        let possibleCells = gameGrid.possibleCells(forCell: selectedCell)
        for possibleCell in possibleCells {
            if possibleCell.state == .inactive {
                let cellButton = buttonForCell(possibleCell)
                cellButton.backgroundColor = Colors.possible
                possibleCell.state = .possible
            }
        }
    }

    /**
     Restore the view for all the possible cells with respect the given selected cell.
     */
    private func unsetPossibleCells(for selectedCell: GridCell) {
        let possibleCells = gameGrid.possibleCells(forCell: selectedCell)
        for possibleCell in possibleCells {
            if possibleCell.state == .possible {
                let cellButton = buttonForCell(possibleCell)
                cellButton.backgroundColor = Colors.inactive
                possibleCell.state = .inactive
            }
        }
    }
    
    /**
     Activate the given cell by changing its state and the button color.
     
     - Note: it also update the grid view in order to show all possible cells.
     */
    private func activateCell(_ selectedCell: GridCell, forButton button: UIButton) {
        button.pulse()
        selectedCell.state = .active
        button.backgroundColor = Colors.active
        setPossibleCells(for: selectedCell)
        selectionHistory.append(selectedCell)
        scoreCounter += 1
    }
    
    /**
     Deactivate the given cell by changing its state and button color.
     
     - Note: is also update the grid view in order to hide all possible cells.
     */
    private func deactivateCell(_ selectedCell: GridCell, forButton button: UIButton) {
        button.pulse()
        selectedCell.state = .possible
        button.backgroundColor = Colors.possible
        unsetPossibleCells(for: selectedCell)
        selectionHistory.removeLast()
        scoreCounter -= 1
    }
    
    // MARK: - Button's actions
    
    /**
     The method to execute when the reset button is tapped.
     */
    @objc func resetTapped(_ button: UIButton) {
        button.pulse()
        gameGrid.forAllCellsPerform{ $0.state = .inactive }
        isGameStarted = false
        scoreCounter = 0
        selectionHistory.removeAll()
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let stackView = gridView.arrangedSubviews[row] as! UIStackView
                let button = stackView.arrangedSubviews[column] as! UIButton
                button.backgroundColor = Colors.inactive
            }
        }
    }
    
    /**
     The method to execute when a cell in the grid is tapped.
     */
    @objc func tapCell(_ button: UIButton)
    {
        guard let buttonID = button.accessibilityIdentifier else { return }
        guard let selectedCell = gameGrid.cellAt(sequentialIdentifier: buttonID) else { return }
        
        if isGameStarted {
            switch selectedCell.state {
            case .possible:
                if let lastCell = lastSelectedCell {
                    lastCell.state = .used
                    buttonForCell(lastCell).backgroundColor = Colors.used
                    unsetPossibleCells(for: lastCell)
                }
                activateCell(selectedCell, forButton: button)
            case .active:
                deactivateCell(selectedCell, forButton: button)
                if let lastCell = lastSelectedCell {
                    lastCell.state = .active
                    buttonForCell(lastCell).backgroundColor = Colors.active
                    setPossibleCells(for: lastCell)
                } else {
                    selectedCell.state = .inactive
                    button.backgroundColor = Colors.inactive
                    isGameStarted = false
                }
            case .inactive:
                break   // Do nothing
            case .used:
                break   // Do nothing
            }
        } else {
            gameGrid.forAllCellsPerform{ $0.state = .inactive }
            activateCell(selectedCell, forButton: button)
            isGameStarted = true
        }
    }
}

