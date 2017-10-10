//
//  GridCell.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 09/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import Foundation

class GridCell
{
    let position: (row: Int, column: Int)
    var row: Int {
        return position.row
    }
    var column: Int {
        return position.column
    }
    var sequentialIndex: Int {
        if let numberOfColumns = mainGrid?.numberOfColumns {
            return position.row * numberOfColumns + position.row
        } else {
            return -1
        }
    }
    
    enum CellState {
        case inactive
        case active
        case used
        case possible
    }
    
    var state: CellState
    
    // A reference to the grid container
    private var mainGrid: GameGrid?
    
    init?(atRow row: Int, andColumn column: Int, inGrid grid: GameGrid, withState state: CellState = .possible) {
        self.mainGrid = grid
        if mainGrid?[row, column] == nil {
            self.position = (row, column)
            self.state = state
        } else {
            // Cell already created at (row, column)
            return nil
        }
    }
    
    init?(atPosition position: (row: Int, column: Int), inGrid grid: GameGrid, withState state: CellState = .possible) {
        self.mainGrid = grid
        if mainGrid?[position] == nil {
            self.position = position
            self.state = state
        } else {
            // Cell already created at (row, column)
            return nil
        }
    }
    
    enum DiagonalDirection {
        case upLeft
        case upRight
        case downLeft
        case downRight
    }
    
    func left() -> GridCell? {
        let leftCell = mainGrid?[position.row, position.column-1]
        return leftCell
    }
    func right() -> GridCell? {
        let righCell = mainGrid?[position.row, position.column+1]
        return righCell
    }
    func up() -> GridCell? {
        let upCell = mainGrid?[position.row-1, position.column]
        return upCell
    }
    func down() -> GridCell? {
        let downCell = mainGrid?[position.row+1, position.column]
        return downCell
    }
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
