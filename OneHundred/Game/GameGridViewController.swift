//
//  ViewController.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 07/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import UIKit

final class GameGridViewController: ViewController {
    
    @IBOutlet private var gridView: GridView!
    
    @IBOutlet private var resetButton: Button!
    @IBOutlet private var scoreLabel: Label!
    @IBOutlet private var cancelButton: Button!
    
    // MARK: - Model
    private var gameGrid: GameGrid!
    
    private var numberOfRows: Int = 10
    private var numberOfColumns: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameGrid = GameGrid(numberOfRows: numberOfRows, numberOfColumns: numberOfColumns)
        
        gridView.configure(numberOfRows: numberOfRows, numberOfColumns: numberOfColumns)
        gridView.delegate = self
    }
    
    private var stopSolving = true
    
    private let mainQueue = DispatchQueue.main
    private let backgroudQueue = DispatchQueue.global(qos: .userInitiated)
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ button: Button) {
        button.pulse()
        if let selectedCell = gameGrid.lastSelectedCell {
            let cellButton = gridView.button(for: selectedCell)
            deactivateCell(selectedCell, forButton: cellButton)
            if let lastCell = gameGrid.lastSelectedCell {
                lastCell.state = .active
                gridView.button(for: lastCell).backgroundColor = Colors.active
                setPossibleCells(for: lastCell)
            } else {
                selectedCell.state = .inactive
                cellButton.backgroundColor = Colors.inactive
            }
        }
    }
    
    @IBAction func resetButtonTapped(_ button: Button) {
        button.pulse()
        gameGrid.forAllCellsPerform{ $0.state = .inactive }
        scoreCounter = 0
        gameGrid.selectionHistory.removeAll()
        gridView.reset()
    }
}

extension GameGridViewController: StoryboardInstantiable {
    static var storyboard: Storyboard { return .game }
}

// MARK: - Private

extension GameGridViewController {
    
    private var scoreCounter: Int {
        get {
            return gameGrid.gameScore
        }
        set {
            gameGrid.gameScore = newValue
            scoreLabel.text = String(newValue)
        }
    }
    
    /// Update the view for all the possible cells with respect the given selected cell.
    private func setPossibleCells(for selectedCell: GridCell) {
        let possibleCells = gameGrid.possibleCells(forCell: selectedCell)
        for possibleCell in possibleCells {
            if possibleCell.state == .inactive {
                let cellButton = gridView.button(for: possibleCell)
                cellButton.backgroundColor = Colors.possible
                possibleCell.state = .possible
            }
        }
    }

    /// Restore the view for all the possible cells with respect the given selected cell.
    private func unsetPossibleCells(for selectedCell: GridCell) {
        let possibleCells = gameGrid.possibleCells(forCell: selectedCell)
        for possibleCell in possibleCells {
            if possibleCell.state == .possible {
                let cellButton = gridView.button(for: possibleCell)
                cellButton.backgroundColor = Colors.inactive
                possibleCell.state = .inactive
            }
        }
    }
    
    /**
     Activate the given cell by changing its state and the button color.
     
     - Note: it also update the grid view in order to show all possible cells.
     */
    private func activateCell(_ selectedCell: GridCell, forButton button: Button) {
        button.pulse()
        selectedCell.state = .active
        button.backgroundColor = Colors.active
        setPossibleCells(for: selectedCell)
        gameGrid.selectionHistory.append(selectedCell)
        scoreCounter += 1
        button.setTitle(String(scoreCounter), for: .normal)
    }
    
    /**
     Deactivate the given cell by changing its state and button color.
     
     - Note: is also update the grid view in order to hide all possible cells.
     */
    private func deactivateCell(_ selectedCell: GridCell, forButton button: Button) {
        button.pulse()
        selectedCell.state = .possible
        button.backgroundColor = Colors.possible
        unsetPossibleCells(for: selectedCell)
        gameGrid.selectionHistory.removeLast()
        scoreCounter -= 1
        button.setTitle("", for: .normal)
    }
    
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
                        let cellButton = gridView.button(for: lastCell)
                        gridView.tapCell(cellButton)
                    }
                } else {
                    // Solved
                }
            } else {
                // Choose one possible cell and RECURSION
                for cell in possibleCells {
                    if stopSolving { return }
                    mainQueue.sync {
                        let cellButton = self.gridView.button(for: cell)
                        gridView.tapCell(cellButton)
                    }
                    usleep(timeToPause)
                    solveGameGraphically()
                }
                if stopSolving { return }
                // If all possible cells are already tried, backtrack
                usleep(timeToPause)
                mainQueue.sync {
                    let cellButton = gridView.button(for: lastCell)
                    gridView.tapCell(cellButton)
                }
            }
        } else { // Start the game from a random cell
            mainQueue.sync {
                let randomFrom0To99 = Int.random(in: 0..<100)
                let randomCell = self.gameGrid.cellAt(sequentialIndex: randomFrom0To99)!
                let randomButton = self.gridView.button(for: randomCell)
                gridView.tapCell(randomButton)
            }
            usleep(timeToPause)
            solveGameGraphically()
        }
    }
    
    // MARK: - Button's actions
    
    /// The method to exeute when the "solve" button is tapped
    @objc func tapSolve(_ button: Button) {
        if !stopSolving {   // the game is actually solving (not stopped)
            stopSolving = true
//            solveButton.setTitle("Solve", for: .normal)
//            solveButton.setTitleColor(UIColor.green, for: .normal)
//            solveButton.layer.borderColor = UIColor.green.cgColor
//            spinIndicator.stopAnimating()
//            solutionLoadingLabel.isHidden = true
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
//            solveButton.setTitle("Stop", for: .normal)
//            solveButton.setTitleColor(UIColor.red, for: .normal)
//            solveButton.layer.borderColor = UIColor.red.cgColor
//            spinIndicator.startAnimating()
//            solutionLoadingLabel.isHidden = false
        }
    }
}

extension GameGridViewController: GridViewDelegate {
    
    func gridView(_ gridView: GridView, didTapOnButton button: Button) {
        guard let buttonID = button.accessibilityIdentifier else { return }
        guard let selectedCell = gameGrid.cellAt(sequentialIdentifier: buttonID) else { return }
        
        if gameGrid.isGameStarted {
            switch selectedCell.state {
            case .possible:
                if let lastCell = gameGrid.lastSelectedCell {
                    lastCell.state = .used
                    gridView.button(for: lastCell).backgroundColor = Colors.used
                    unsetPossibleCells(for: lastCell)
                }
                activateCell(selectedCell, forButton: button)
            case .active:
                deactivateCell(selectedCell, forButton: button)
                if let lastCell = gameGrid.lastSelectedCell {
                    lastCell.state = .active
                    gridView.button(for: lastCell).backgroundColor = Colors.active
                    setPossibleCells(for: lastCell)
                } else {
                    selectedCell.state = .inactive
                    button.backgroundColor = Colors.inactive
                }
            case .inactive: break   // Do nothing
            case .used: break   // Do nothing
            }
        } else {
            gameGrid.forAllCellsPerform{ $0.state = .inactive }
            activateCell(selectedCell, forButton: button)
        }
    }
}
