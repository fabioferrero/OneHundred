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
    // The solving loading label and activity indicator
    var solutionLoadingLabel: UILabel!
    var spinIndicator: UIActivityIndicatorView!
    // The back button
    var backButton: UIButton!
    
    // MARK: - Model
    
    // The model for the grid
    var gameGrid: GameGrid!
    
    // MARK: - Controller
    
    var numberOfRows = 10
    var numberOfColumns = 10
    
    var stopSolving = true
    
    private var scoreCounter: Int {
        get {
            return gameGrid.gameScore
        }
        set {
            gameGrid.gameScore = newValue
            scoreLabel.text = String(newValue)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Instanciate the model
        gameGrid = GameGrid(withRows: numberOfRows, andColumns: numberOfColumns)!
        
        // Instanciate the view
        setupLayout()
        
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
        scoreLabel.widthAnchor.constraint(equalToConstant: 40).isActive = active
    }
    
    private func setupBackButtonConstraintsForPortrait(_ active: Bool)
    {
        backButton.trailingAnchor.constraint(equalTo: gridView.trailingAnchor).isActive = active
        backButton.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor).isActive = active
    }
    
    private func setupSolutionLoadingConstraintForPortrait(_ active: Bool)
    {
        spinIndicator.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 20).isActive = active
        spinIndicator.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor).isActive = active
        solutionLoadingLabel.leadingAnchor.constraint(equalTo: spinIndicator.trailingAnchor, constant: 10).isActive = active
        solutionLoadingLabel.centerYAnchor.constraint(equalTo: spinIndicator.centerYAnchor).isActive = active
    }
    
    private func setupConstraintsForPortrait(_ active: Bool)
    {
        setupGridConstraintsForPortrait(active)
        setupResetButtonConstraintsForPortrait(active)
        setupSolveButtonConstraintsForPortrait(active)
        setupScoreLabelConstraintsForPortrait(active)
        setupBackButtonConstraintsForPortrait(active)
        setupSolutionLoadingConstraintForPortrait(active)
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
    
    private func setupSolutionLoadingLayout()
    {
        solutionLoadingLabel = UILabel()
        view.addSubview(solutionLoadingLabel)
        spinIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.addSubview(spinIndicator)
        
        solutionLoadingLabel.translatesAutoresizingMaskIntoConstraints = false
        solutionLoadingLabel.text = "Finding a solution..."
        solutionLoadingLabel.font = UIFont.systemFont(ofSize: 22)
        solutionLoadingLabel.isHidden = true
        
        spinIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout()
    {
        setupGridLayout()
        setupResetButtonLayout()
        setupSolveButtonLayout()
        setupScoreLabelLayout()
        setupBackButtonLayout()
        setupSolutionLoadingLayout()
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
        gameGrid.selectionHistory.append(selectedCell)
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
        gameGrid.selectionHistory.removeLast()
        scoreCounter -= 1
    }
    
    /**
     Returns a random integer that is in between the specified lower and upper bounds.
     */
    private func randomInt(from lowerBound: Int, to upperBound: Int) -> Int?
    {
        guard lowerBound < upperBound else { return nil }
        let difference = Double(upperBound - lowerBound)
        return Int(Double(arc4random()) / Double(UInt32.max) * difference) + lowerBound
    }
    
    private let mainQueue = DispatchQueue.main
    private let backgroudQueue = DispatchQueue.global(qos: .userInitiated)
    
    /**
     Find a solution of the game using a recursive greedy approach with backtrack.
     
     TODO: move to graphic solution finder to only computation finder, while shows graphically
     only the founded solution.
     */
    private func solveGameGraphically() {
        let timeToPause: UInt32 = 200000 // pause for 0.2 second
        if stopSolving { return }
        if let lastCell = gameGrid.lastSelectedCell {
            let possibleCells = gameGrid.possibleCells(forCell: lastCell).filter { $0.state == .possible }
            if possibleCells.isEmpty {
                if !gameGrid.isGameSolved {
                    // Backtrack
                    usleep(timeToPause)
                    mainQueue.sync {
                        let cellButton = buttonForCell(lastCell)
                        self.tapCell(cellButton)
                    }
                } else {
                    // Solved
                }
            } else {
                // Choose one possible cell and RECURSION
                for cell in possibleCells {
                    if stopSolving { return }
                    mainQueue.sync {
                        let cellButton = self.buttonForCell(cell)
                        self.tapCell(cellButton)
                    }
                    usleep(timeToPause)
                    solveGameGraphically()
                }
                if stopSolving { return }
                // If all possible cells are already tried, backtrack
                usleep(timeToPause)
                mainQueue.sync {
                    let cellButton = buttonForCell(lastCell)
                    self.tapCell(cellButton)
                }
            }
        } else { // Start the game from a random cell
            mainQueue.sync {
                let randomFrom0To99 = self.randomInt(from: 0, to: 99)!
                let randomCell = self.gameGrid.cellAt(sequentialIndex: randomFrom0To99)!
                let randomButton = self.buttonForCell(randomCell)
                self.tapCell(randomButton)
            }
            usleep(timeToPause)
            solveGameGraphically()
        }
    }
    
    // MARK: - Button's actions
    
    /**
     The method to execute when the reset button is tapped.
     */
    @objc func tapReset(_ button: UIButton) 
    {
        button.pulse()
        gameGrid.forAllCellsPerform{ $0.state = .inactive }
        scoreCounter = 0
        gameGrid.selectionHistory.removeAll()
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
        if let selectedCell = gameGrid.lastSelectedCell {
            let cellButton = buttonForCell(selectedCell)
            deactivateCell(selectedCell, forButton: cellButton)
            if let lastCell = gameGrid.lastSelectedCell {
                lastCell.state = .active
                buttonForCell(lastCell).backgroundColor = Colors.active
                setPossibleCells(for: lastCell)
            } else {
                selectedCell.state = .inactive
                cellButton.backgroundColor = Colors.inactive
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
        
        if gameGrid.isGameStarted {
            switch selectedCell.state {
            case .possible:
                if let lastCell = gameGrid.lastSelectedCell {
                    lastCell.state = .used
                    buttonForCell(lastCell).backgroundColor = Colors.used
                    unsetPossibleCells(for: lastCell)
                }
                activateCell(selectedCell, forButton: button)
            case .active:
                deactivateCell(selectedCell, forButton: button)
                if let lastCell = gameGrid.lastSelectedCell {
                    lastCell.state = .active
                    buttonForCell(lastCell).backgroundColor = Colors.active
                    setPossibleCells(for: lastCell)
                } else {
                    selectedCell.state = .inactive
                    button.backgroundColor = Colors.inactive
                }
            case .inactive:
                break   // Do nothing
            case .used:
                break   // Do nothing
            }
        } else {
            gameGrid.forAllCellsPerform{ $0.state = .inactive }
            activateCell(selectedCell, forButton: button)
        }
    }
    
    /**
     The method to exeute when the "solve" button is tapped
     */
    @objc func tapSolve(_ button: UIButton)
    {
        if !stopSolving {   // the game is actually solving (not stopped)
            stopSolving = true
            solveButton.setTitle("Solve", for: .normal)
            solveButton.setTitleColor(UIColor.green, for: .normal)
            solveButton.layer.borderColor = UIColor.green.cgColor
            spinIndicator.stopAnimating()
            solutionLoadingLabel.isHidden = true
        } else {            // the game is not solving (is stopped)
            backgroudQueue.async {
                self.solveGameGraphically()
//                self.gameGrid.findASolution {
//                    print(self.gameGrid.selectionHistory.map {
//                        "(\($0.row),\($0.column))"
//                    })
//                }
            }
            stopSolving = false
            solveButton.setTitle("Stop", for: .normal)
            solveButton.setTitleColor(UIColor.red, for: .normal)
            solveButton.layer.borderColor = UIColor.red.cgColor
            spinIndicator.startAnimating()
            solutionLoadingLabel.isHidden = false
        }
    }
}

