//
//  GridCell.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 09/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import Foundation

/// A cell with a state and properties that is the main component of a GameGrid.
class GridCell {
    
    let row: Int
    let column: Int
    
    /// The position of the cell into the grid as (row, column).
    var position: (row: Int, column: Int) {
        return (row, column)
    }
    
    /// The current state of the cell.
    var state: CellState
    
    enum CellState {
        case inactive
        case active
        case used
        case possible
    }
    
    /// The cell sequential index corresponding to its 2D coordinates translated in 1D.
    var sequentialIndex: Int {
        return position.row * cellGrid.numberOfColumns + position.row
    }
    
    /// A private reference to the grid that contains the cell.
    private let cellGrid: GameGrid
    
    /// Creates and returns a new cell at specified position and state.
    init?(atRow row: Int, andColumn column: Int, inGrid grid: GameGrid, withState state: CellState = .possible) {
        self.cellGrid = grid
        if cellGrid[row, column] == nil {
            self.row = row
            self.column = column
            self.state = state
        } else {
            // Cell already created at (row, column)
            return nil
        }
    }
    
    /// Creates and returns a new cell at specified position and state.
    init?(atPosition position: (row: Int, column: Int), inGrid grid: GameGrid, withState state: CellState = .possible) {
        self.cellGrid = grid
        if cellGrid[position] == nil {
            self.row = position.row
            self.column = position.column
            self.state = state
        } else {
            // Cell already created at (row, column)
            return nil
        }
    }
    
    /// Returns the left adiacent cell to the caller cell in the grid, if present.
    func left() -> GridCell? {
        let leftCell = cellGrid[position.row, position.column-1]
        return leftCell
    }
    
    /// Returns the right adiacent cell to the caller cell in the grid, if present.
    func right() -> GridCell? {
        let righCell = cellGrid[position.row, position.column+1]
        return righCell
    }
    
    /// Returns the top adiacent cell to the caller cell in the grid, if present.
    func up() -> GridCell? {
        let upCell = cellGrid[position.row-1, position.column]
        return upCell
    }
    
    /// Returns the bottom adiacent cell to the caller cell in the grid, if present.
    func down() -> GridCell? {
        let downCell = cellGrid[position.row+1, position.column]
        return downCell
    }
    
    enum DiagonalDirection {
        case upLeft
        case upRight
        case downLeft
        case downRight
    }
    
    /// Returns the diagonal adiacent cell to the caller cell in the grid, if present.
    func diagonal(_ direction: DiagonalDirection) -> GridCell? {
        switch direction {
        case .upLeft:
            return self.up()?.left()
        case .upRight:
            return self.up()?.right()
        case .downLeft:
            return self.down()?.left()
        case .downRight:
            return self.down()?.right()
        }
    }
}
