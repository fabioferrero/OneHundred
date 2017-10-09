//
//  GameGrid.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 07/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import Foundation

enum DiagonalDirection {
    case upLeft
    case upRight
    case downLeft
    case downRight
}

struct GridCell
{
    let position: (row: Int, column: Int)
    var row: Int {
        return position.row
    }
    var column: Int {
        return position.column
    }
    
    var isActive = false
    var isPossible = false
    var isUsed = false
    
    // A reference to the grid container
    private var mainGrid: GameGrid?
    
    init(atRow row: Int, andColumn column: Int, inGrid grid: GameGrid) {
        self.position = (row, column)
        self.mainGrid = grid
    }
    
    init(atPosition position: (Int, Int), inGrid grid: GameGrid) {
        self.position = position
        self.mainGrid = grid
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

class GameGrid
{
    let numberOfRows: Int
    let numberOfColumns: Int
    
    var mainGrid: [[GridCell]]
    
    init?(withRows numberOfRows: Int, andColumns numberOfColumns: Int)
    {
        guard numberOfRows > 0 && numberOfColumns > 0 else {
            return nil
        }
        
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        
        mainGrid = [[GridCell]]()
        for rowIndex in 0..<numberOfRows {
            var row = [GridCell]()
            for columnIndex in 0..<numberOfColumns {
                let cell = GridCell(atPosition: (rowIndex, columnIndex), inGrid: self)
                row.append(cell)
            }
            mainGrid.append(row)
        }
    }
    
    func isValidCellIndex(row: Int, column: Int) -> Bool
    {
        return row >= 0 && row < numberOfRows && column >= 0 && column < numberOfColumns
    }
    
    subscript(row: Int, column: Int) -> GridCell?
    {
        get {
            if isValidCellIndex(row: row, column: column) {
                return mainGrid[row][column]
            } else {
                return nil
            }
        }
        set {
            if isValidCellIndex(row: row, column: column) {
                mainGrid[row][column] = newValue! // This will crash if newValue = nil
            }
        }
    }
    
}
