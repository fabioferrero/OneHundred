//
//  GameGrid.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 07/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import Foundation

/// A grid model that contains instances of GridCells class.
class GameGrid {
    
    /// The number of rows in the grid.
    let numberOfRows: Int
    
    /// The number of columns in the grid.
    let numberOfColumns: Int
    
    /// The internal array that implements the matrix layout.
    private var mainGrid: [GridCell?]
    
    /// The history of all selected cell so far.
    var selectionHistory: [GridCell]
    
    /// An array containing the ordered sequence for a solution, if any.
    var solution: [GridCell]?
    
    /// The current score of the game.
    var gameScore: Int
    
    /// Create a new GameGrid with specified numberOfRows and numberOfColumns.
    init?(numberOfRows: Int, numberOfColumns: Int) {
        guard numberOfRows > 0 && numberOfColumns > 0 else {
            return nil
        }
        
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        
        self.selectionHistory = [GridCell]()
        
        self.gameScore = 0
        
        // Matrix Initialization
        mainGrid = Array<GridCell?>(repeating: nil, count: numberOfRows * numberOfColumns)
        for rowIndex in 0..<numberOfRows {
            for columnIndex in 0..<numberOfColumns {
                mainGrid[matrixIndex(rowIndex, columnIndex)] = GridCell(atRow: rowIndex, andColumn: columnIndex, inGrid: self)
            }
        }
    }
}

// MARK: - Computed Properties

extension GameGrid {
    
    /// The last selected cell in the current history, if any.
    var lastSelectedCell: GridCell? {
        return selectionHistory.last
    }
    
    /// The last selected cell in the current solution, if any.
    var lastSolutionCell: GridCell? {
        return solution?.last
    }
    
    /// Tell if the game is already started or not.
    var isGameStarted: Bool {
        return selectionHistory.last == nil ? false : true
    }
    
    /// Tell if the game is actually solved or not.
    var isGameSolved: Bool {
        return gameScore == 100 ? true : false
    }
    
    /// Tell if a solution is found
    var isSolutionFound: Bool {
        return (solution?.count ?? 0 == 100) ? true : false
    }
}

// MARK: - Private

extension GameGrid {
    
    /// Check the validity of the given coordinates for a cell inside the grid.
    private func isValidCellIndex(row: Int, column: Int) -> Bool {
        return row >= 0 && row < numberOfRows && column >= 0 && column < numberOfColumns
    }
    
    /// Translate 2D coordinate (row, column) into the sequential index for
    /// accessing the internal array.
    private func matrixIndex(_ row: Int, _ column: Int) -> Int {
        return row * numberOfColumns + column
    }
    
    /// Update all the possible cells with respect the given selected cell.
    private func setPossibleCells(for selectedCell: GridCell) {
        let possibles = possibleCells(forCell: selectedCell)
        for possibleCell in possibles {
            if possibleCell.state == .inactive {
                possibleCell.state = .possible
            }
        }
    }
    
    /// Restore all the possible cells with respect the given selected cell.
    private func unsetPossibleCells(for selectedCell: GridCell) {
        let possibles = possibleCells(forCell: selectedCell)
        for possibleCell in possibles {
            if possibleCell.state == .possible {
                possibleCell.state = .inactive
            }
        }
    }
    
    /**
     Activate the given cell by changing its state.
     
     - Note: this method also update the state of all possible cells related to the specified one.
     */
    private func activateCell(_ selectedCell: GridCell) {
        selectedCell.state = .active
        setPossibleCells(for: selectedCell)
        selectionHistory.append(selectedCell)
        gameScore += 1
    }
    
    /**
     Deactivate the given cell by changing its state.
     
     - Note: this method also update the state of all possible cells related to the specified one.
     */
    private func deactivateCell(_ selectedCell: GridCell) {
        selectedCell.state = .possible
        unsetPossibleCells(for: selectedCell)
        selectionHistory.removeLast()
        gameScore -= 1
    }
}

// MARK: - API

extension GameGrid {
    
    /// Returns a collection of cells that are reacheables from the cell parameter.
    /// It supposes the cell being in the grid.
    func possibleCells(forCell cell: GridCell) -> [GridCell] {
        var cellArray = [GridCell]()
        if let possibleCell = cell.diagonal(.upLeft)?.diagonal(.upLeft) {
            cellArray.append(possibleCell)  // top-left
        }
        if let possibleCell = cell.up()?.up()?.up() {
            cellArray.append(possibleCell)  // up
        }
        if let possibleCell = cell.diagonal(.upRight)?.diagonal(.upRight) {
            cellArray.append(possibleCell)  // top-right
        }
        if let possibleCell = cell.right()?.right()?.right() {
            cellArray.append(possibleCell)  // right
        }
        if let possibleCell = cell.diagonal(.downRight)?.diagonal(.downRight) {
            cellArray.append(possibleCell)  // down-right
        }
        if let possibleCell = cell.down()?.down()?.down() {
            cellArray.append(possibleCell)  // down
        }
        if let possibleCell = cell.diagonal(.downLeft)?.diagonal(.downLeft) {
            cellArray.append(possibleCell)  // down-left
        }
        if let possibleCell = cell.left()?.left()?.left() {
            cellArray.append(possibleCell)  // left
        }
        return cellArray
    }
    
    /**
     Change the state of the specified cell inside the grid accordingly to its current state.
     
     - Note: this method also update the state of all possible cells related to the specified one.
     */
    func changeState(for cell: GridCell) {
        switch cell.state {
        case .possible:
            if let lastCell = lastSelectedCell {
                lastCell.state = .used
                unsetPossibleCells(for: lastCell)
            }
            activateCell(cell)
        case .active:
            deactivateCell(cell)
            if let lastCell = lastSelectedCell {
                lastCell.state = .active
                setPossibleCells(for: lastCell)
            } else {
                cell.state = .inactive
            }
        case .inactive:
        break   // Do nothing
        case .used:
            break   // Do nothing
        }
    }
    
    /**
     Find a solution of the game using a recursive greedy approach with backtrack.
     
     - Warning: This function is time consuming, so it must be called outside the main queue.
     - Parameters:
         - callback: A closure that is called after a solution is found.
     - Note: The game must be started.
     */
    func findASolution(_ callback: () -> () ) -> [GridCell]? {
        // Copy the state of the game in the solution
        solution = [GridCell](selectionHistory)
        solveGame()
        callback()
        return solution
    }
}

// MARK: - Utility

extension GameGrid {
    
    /// Perform the same action on all cell inside the grid.
    func forAllCellsPerform(_ action: (GridCell) -> ()) {
        for element in mainGrid {
            if let cell = element {
                action(cell)
            }
        }
    }
    
    /// Returns the cell at the specified sequentialIndex inside the grid.
    func cellAt(sequentialIndex index: Int) -> GridCell? {
        if index >= numberOfRows * numberOfColumns || index < 0 {
            return nil
        }
        return mainGrid[index]
    }
    
    /// Returns the cell that corresponds to the sequentialIdentifier inside th grid.
    func cellAt(sequentialIdentifier id: String) -> GridCell? {
        guard let index = Int(id) else {
            print("Impossible to translate index from string")
            return nil
        }
        if index >= numberOfRows * numberOfColumns || index < 0 {
            return nil
        }
        return mainGrid[index]
    }
}

// MARK: - Solving Engine

extension GameGrid {
    
    /**
     Find a solution of the game using a recursive greedy approach with backtrack.
     It computes a possible solution for the actual state of the game and save it into a local variable
     
     - Note: the game must be started.
     */
    private func solveGame() {
        if let lastCell = lastSelectedCell {
            let possibles = possibleCells(forCell: lastCell).filter { $0.state == .possible }
            if possibles.isEmpty {
                if isSolutionFound {
                    // Solved
                    // Save the result on disk if not yet found
                } else {
                    // Backtrack
                    deactivateCell(lastCell)
                    if let lastCell = lastSelectedCell {
                        lastCell.state = .active
                        setPossibleCells(for: lastCell)
                    }
                }
            } else {
                // Choose one possible cell and RECURSION
                for cell in possibles {
                    lastCell.state = .used
                    unsetPossibleCells(for: lastCell)
                    activateCell(cell)
                    solveGame()
                }
                // If all possible cells are already tried, backtrack
                deactivateCell(lastCell)
                if let lastCell = lastSelectedCell {
                    lastCell.state = .active
                    setPossibleCells(for: lastCell)
                }
            }
        }
    }
}

// MARK: - Subscript

extension GameGrid {
    
    /// Subscript syntax for calls as grid[row, column]
    subscript(row: Int, column: Int) -> GridCell? {
        get {
            if isValidCellIndex(row: row, column: column) {
                return mainGrid[matrixIndex(row, column)]
            } else {
                return nil
            }
        }
        set {
            if isValidCellIndex(row: row, column: column) {
                mainGrid[matrixIndex(row, column)] = newValue
            }
        }
    }
    
    /// Subscript syntax for calls as grid[position] with position as tuple (row, column)
    subscript(position: (row: Int, column: Int)) -> GridCell? {
        get { return self[position.row, position.column] }
        set { self[position.row, position.column] = newValue }
    }
}

