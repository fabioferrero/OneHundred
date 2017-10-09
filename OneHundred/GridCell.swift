//
//  GridCell.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 09/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import Foundation

struct GridCell
{
    let position: (row: Int, column: Int)
    var row: Int {
        return position.row
    }
    var column: Int {
        return position.column
    }
    
    var isUsed = false
    var isActive = false
    
    var isPossible = false
    
    // A reference to the grid container
    private var mainGrid: GameGrid?
    
    init?(atRow row: Int, andColumn column: Int, inGrid grid: GameGrid) {
        self.mainGrid = grid
        if mainGrid?[row, column] == nil {
            self.position = (row, column)
        } else {
            // Cell already created at (row, column)
            return nil
        }
    }
    
    init?(atPosition position: (row: Int, column: Int), inGrid grid: GameGrid) {
        self.mainGrid = grid
        if mainGrid?[position] == nil {
            self.position = position
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
    func diagonal(direction: DiagonalDirection) -> GridCell? {
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
