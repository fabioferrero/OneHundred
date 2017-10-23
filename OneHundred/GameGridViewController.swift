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
    // The solve button
    var solveButton: UIButton!
    // The score label
    var scoreLabel: UILabel!
    // The back button
    var backButton: UIButton!
    
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
        setupLayout()
    }
    
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()

        setupConstraintsForPortrait(true)
    }
    
    private struct Colors {
        static let inactive: UIColor = .lightGray
        static let active: UIColor = .red
        static let possible: UIColor = .orange
        static let used: UIColor = .gray
    }
    
    // MARK: - View's Constraints
    
    private func setupGridConstraintsForPortrait(_ active: Bool)
    {
        gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = active
        gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = active
        gridView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = active
        gridView.heightAnchor.constraint(equalTo: gridView.widthAnchor).isActive = active
    }
    
    private func setupResetButtonConstraintsForPortrait(_ active: Bool)
    {
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = active
        resetButton.centerYAnchor.constraint(equalTo: gridView.bottomAnchor, constant: 80).isActive = active
        resetButton.widthAnchor.constraint(equalToConstant: 160).isActive = active
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = active
    }
    
    private func setupSolveButtonConstraintsForPortrait(_ active: Bool)
    {
        solveButton.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor).isActive = active
        solveButton.centerYAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 40).isActive = active
        solveButton.widthAnchor.constraint(equalToConstant: 160).isActive = active
        solveButton.heightAnchor.constraint(equalToConstant: 50).isActive = active
    }
    
    private func setupScoreLabelConstraintsForPortrait(_ active: Bool)
    {
        scoreLabel.leadingAnchor.constraint(equalTo: gridView.leadingAnchor).isActive = active
        scoreLabel.centerYAnchor.constraint(equalTo: gridView.topAnchor, constant: -80).isActive = active
    }
    
    private func setupBackButtonConstraintsForPortrait(_ active: Bool)
    {
        backButton.trailingAnchor.constraint(equalTo: gridView.trailingAnchor).isActive = active
        backButton.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor).isActive = active
    }
    
    private func setupConstraintsForPortrait(_ active: Bool)
    {
        setupGridConstraintsForPortrait(active)
        setupResetButtonConstraintsForPortrait(active)
        setupSolveButtonConstraintsForPortrait(active)
        setupScoreLabelConstraintsForPortrait(active)
        setupBackButtonConstraintsForPortrait(active)
    }
    
    private func setupGridConstraintsForLandscape(_ active: Bool)
    {
        gridView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = active
        gridView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = active
        gridView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9).isActive = active
        gridView.widthAnchor.constraint(equalTo: gridView.heightAnchor).isActive = active
    }
    
    private func setupResetButtonConstraintsForLandscape(_ active: Bool)
    {
        resetButton.centerXAnchor.constraint(equalTo: gridView.trailingAnchor, constant: 100).isActive = active
        resetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = active
        resetButton.widthAnchor.constraint(equalToConstant: 140).isActive = active
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = active
    }
    
    private func setupScoreLabelConstraintsForLandscape(_ active: Bool)
    {
        scoreLabel.trailingAnchor.constraint(equalTo: gridView.leadingAnchor, constant: -80).isActive = active
        scoreLabel.topAnchor.constraint(equalTo: gridView.topAnchor, constant: 80).isActive = active
    }
    
    private func setupBackButtonConstraintsForLandscape(_ active: Bool)
    {
        backButton.trailingAnchor.constraint(equalTo: scoreLabel.trailingAnchor).isActive = active
        backButton.bottomAnchor.constraint(equalTo: gridView.bottomAnchor, constant: -80).isActive = active
    }
    
    private func setupConstraintsForLandscape(_ active: Bool)
    {
        setupGridConstraintsForLandscape(active)
        setupResetButtonConstraintsForLandscape(active)
        setupScoreLabelConstraintsForLandscape(active)
        setupBackButtonConstraintsForLandscape(active)
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
            stackView.translatesAutoresizingMaskIntoConstraints = false
            gridView.addArrangedSubview(stackView)
        }
        
        gridView.axis = .vertical
        gridView.alignment = .fill
        gridView.distribution = .fillEqually
        gridView.spacing = 5.0
        gridView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupResetButtonLayout()
    {
        resetButton = UIButton()
        view.addSubview(resetButton)
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(UIColor.orange, for: .normal)
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = UIColor.orange.cgColor
        resetButton.layer.cornerRadius = 25
        //resetButton.backgroundColor = UIColor.orange
        resetButton.addTarget(self, action: #selector(tapReset(_:)), for: .touchUpInside)
    }
    
    private func setupSolveButtonLayout()
    {
        solveButton = UIButton()
        view.addSubview(solveButton)
        
        solveButton.translatesAutoresizingMaskIntoConstraints = false
        solveButton.setTitle("Solve", for: .normal)
        solveButton.setTitleColor(UIColor.green, for: .normal)
        solveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        solveButton.layer.borderWidth = 2
        solveButton.layer.borderColor = UIColor.green.cgColor
        solveButton.layer.cornerRadius = 25
        solveButton.addTarget(self, action: #selector(tapSolve(_:)), for: .touchUpInside)
    }
    
    private func setupScoreLabelLayout()
    {
        scoreLabel = UILabel()
        view.addSubview(scoreLabel)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    private func setupBackButtonLayout()
    {
        backButton = UIButton()
        view.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("⌫", for: .normal)
        backButton.setTitleColor(UIColor.red, for: .normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        backButton.addTarget(self, action: #selector(tapBack(_:)), for: .touchUpInside)
    }
    
    private func setupLayout()
    {
        setupGridLayout()
        setupResetButtonLayout()
        setupSolveButtonLayout()
        setupScoreLabelLayout()
        setupBackButtonLayout()
    }
    
    // MARK: -
    
    /**
     Returns the button in the view that is related to the given cell in the model.
     */
    private func buttonForCell(_ cell: GridCell) -> UIButton
    {
        let stackView = gridView.arrangedSubviews[cell.row] as! UIStackView
        let cellButton = stackView.arrangedSubviews[cell.column] as! UIButton
        return cellButton
    }
    
    /**
     Update the view for all the possible cells with respect the given selected cell.
     */
    private func setPossibleCells(for selectedCell: GridCell)
    {
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
    private func unsetPossibleCells(for selectedCell: GridCell)
    {
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
    private func activateCell(_ selectedCell: GridCell, forButton button: UIButton)
    {
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
    private func deactivateCell(_ selectedCell: GridCell, forButton button: UIButton)
    {
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
    @objc func tapReset(_ button: UIButton) 
    {
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
     The method to execute when the back button is tapped
     */
    @objc func tapBack(_ button: UIButton)
    {
        if let selectedCell = lastSelectedCell {
            let cellButton = buttonForCell(selectedCell)
            deactivateCell(selectedCell, forButton: cellButton)
            if let lastCell = lastSelectedCell {
                lastCell.state = .active
                buttonForCell(lastCell).backgroundColor = Colors.active
                setPossibleCells(for: lastCell)
            } else {
                selectedCell.state = .inactive
                cellButton.backgroundColor = Colors.inactive
                isGameStarted = false
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
    
    /**
     The method to exeute when the "solve" button is tapped
     */
    @objc func tapSolve(_ button: UIButton)
    {
        //solveGame()
    }
}

